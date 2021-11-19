#!/usr/bin/perl -w
#
# Convert your AVI files (actually anything mplayer can play) into DVD format
# using mplayer, transcode, mjpegtools and dvdauthor
#
# (C) Nick Craig-Wood <nick@craig-wood.com>
#
# TODO
# ====
# 
# Save the config somewhere and make it so it can be loaded in
# Save where we got to in the config file too then we can restart gracefully!
#
# Have a crop to 4:3 or 16:9 option rather than letter box
#
# Use gnu thingy to store scrollbacks for each read_*
#
# Option to use transcode or mplayer
#
# Consider -c --close-gop option to mpeg2enc for better chapter marking
# needs mpeg2enc > ????
#
# Use -i post=rsm on dvdauthor titles to make it continue playing at
# the end of titles?
#
# Use mplayer --identify - has all plus aspect ratio!  Instead of tcprobe -i
# flag for making it quiet?  This will remove the dependency on transcode.

use strict;
use Getopt::Std;
use Cwd;
$|++;

my $SYNTAX = << "#EOS";
Syntax: $0 [-dyh] [<video_file(s)>]+

Attempt to convert AVI to DVD.  Using transcode, mjpegtools and
dvdauthor (>= 0.5.3)

  -d debug - just print what would have been run
  -y automatically accept the defaults for all the questions
  -h show this help

It uses the current working directory for temporary file storage.

Note that the acceptable output formats for DVD are (from DVD FAQ)

  MPEG-2, 525/60 (NTSC): 720x480, 704x480, 352x480
  MPEG-2, 625/50 (PAL):  720x576, 704x576, 352x576
  MPEG-1, 525/60 (NTSC): 352x240
  MPEG-1, 625/50 (PAL):  352x288

We do not support MPEG-1 output yet

#EOS

getopts('dyh', \my %opt) or die $SYNTAX;
die $SYNTAX if $opt{h} || @ARGV < 1;
my $DEBUG = $opt{d};
my $YES = $opt{y};
my (@FILES) = @ARGV;
my $dir = cwd();
my $configs = {};
my $config;
my $FILE;

# Default config

my $default_config =
{
    DVD_SIZE			=> 4500000000,	# bytes in a DVD
    AUDIO_RATE			=> 224,		# mp2 audio rate
    MIN_AUDIO_RATE		=> 64,		# min mp2 audio rate
    MAX_AUDIO_RATE		=> 384,		# max mp2 audio rate
    ACCEPTABLE_ASPECT_SKEW	=> 5,		# percent change in aspect which is acceptable
    PULLDOWN			=> 0,		# 3:2 pulldown
    FORMAT			=> "PAL",	# PAL or NTSC
    FRAMERATE_CODE		=> 3,		# 1..8 see "mpeg2enc -F 0" 
    VIDEO_RATE			=> 6000,	# kbps for video encode
    MAX_VIDEO_RATE		=> 8000,	# kbps max value
    MIN_VIDEO_RATE		=> 2000,	# kbps max value
    ASPECT			=> "4:3",	# 4:3 or 16:9
    WIDTH			=> "704",	# output width
    HEIGHT			=> "576",	# output height
    XBAR			=> 0,		# pixels of bar on left+right
    YBAR			=> 0,		# pixels of bar on top bottom
    INTERLACE			=> 0,		# whether source is interlaced
    OUTPUT			=> "test",	# name of output
    CHAPTER_MINS		=> 5,		# minutes between chapter markers
    TEMP_DIR			=> ".",		# where the temporary files go
    OUTPUT_DIR			=> "dvd",	# where the output files go
};

#check_binaries(qw(transcode tcprobe mpeg2enc mp2enc dvdauthor));
#check_disk($dir, 15);

# Probe each file

my $TOTAL_RUNNING_TIME = 0;
for $FILE (@FILES)
{
    # Start with empty config
    $config = $configs->{$FILE} = { };
    $config->{FILE} = $FILE;
    probe();
    $TOTAL_RUNNING_TIME += $config->{RUNNING_TIME};
}
print "Found ".hms($TOTAL_RUNNING_TIME)." of video\n";

# Options for all the files

$config = $default_config;
$config->{OUTPUT} = $FILES[0];
$config->{OUTPUT} =~ s|^.*/||;
$config->{OUTPUT} =~ s|\..*$||;
read_string("Prefix for output", "OUTPUT");
read_string("Temporary directory", "TEMP_DIR");
read_string("Output directory", "OUTPUT_DIR");

# Ask the user for configuration

my $old_config = $default_config;
for $FILE (@FILES)
{
    # Overwrite anything which isn't already set with the last used value
    $config = $configs->{$FILE};
    for my $key (%$old_config)
    {
	$config->{$key} = $old_config->{$key}
  	    unless defined $config->{$key};
    }
    configure();
}

# Now we've decided everything run stuff!

my $start = time();
for $FILE (@FILES)
{
    $config = $configs->{$FILE};
    transcode();
}
finalise();
my $elapsed = time()-$start;
print "That took ".hms($elapsed)." (${elapsed}s)\n";

exit;

############################################################
# Probe the file to discover its essential properties such as width,
# height, fps, running time etc
############################################################

sub probe
{
    die "Can't read $config->{FILE}" unless -r $config->{FILE};
    $config->{QFILE} = quotemeta($config->{FILE});
    my $probe = `tcprobe -i $config->{QFILE} 2>&1`;

    die "Can't read frame size from $probe"
	unless $probe =~ /import frame size: -g (\d+)x(\d+)/;
    ($config->{IN_WIDTH}, $config->{IN_HEIGHT}) = ($1, $2);

    die "Can't read frame rate from $probe"
	unless $probe =~ /frame rate: -f ([0-9.]+)/;
    $config->{FPS} = $1;
       
    die "Can't length from $probe"
	unless $probe =~ /length: (\d+) frames/;
    $config->{FRAMES} = $1;

    $config->{RUNNING_TIME} = $config->{FRAMES} / $config->{FPS};

    $config->{IN_ASPECT} = $config->{IN_WIDTH}/$config->{IN_HEIGHT};

    if ($config->{FPS} >= 23.96 && $config->{FPS} <= 23.98)
    {
	$config->{FORMAT} = "NTSC";
	$config->{PULLDOWN} = 1;
	$config->{FRAMERATE_CODE} = 1;
    }
    elsif ($config->{FPS} == 24)
    {
	$config->{FORMAT} = "NTSC";
	$config->{PULLDOWN} = 1;
	$config->{FRAMERATE_CODE} = 2;
    }
    elsif ($config->{FPS} == 25)
    {
	$config->{FORMAT} = "PAL";
	$config->{FRAMERATE_CODE} = 3;
    }
    elsif ($config->{FPS} >= 29.96 && $config->{FPS} <= 29.98)
    {
	$config->{FORMAT} = "NTSC";
	$config->{FRAMERATE_CODE} = 4;
    }
    elsif ($config->{FPS} == 30)
    {
	$config->{FORMAT} = "NTSC";
	$config->{FRAMERATE_CODE} = 5;
    }
    else
    {
	die "Can't figure out what to do with a $config->{FPS} fps video file!\n";
    }

}

############################################################
# Ask the user about exactly what to do with the file
############################################################

sub configure
{
    print "------------------------------------------------------------\n";
    print "Configuring for: $config->{FILE}\n";
    printf "$config->{IN_WIDTH}x$config->{IN_HEIGHT} @ $config->{FPS} fps running for %s (%.1fs) aspect %.3f\n",
        hms($config->{RUNNING_TIME}), $config->{RUNNING_TIME}, $config->{IN_ASPECT};
    print "------------------------------------------------------------\n";
    read_number("Aspect ratio of input file (4:3 = 1.333 16:9 = 1.778)", "IN_ASPECT", 0, 10);

    print "This is best encoded as $config->{FORMAT}";
    print " with 3:2 pulldown" if $config->{PULLDOWN};
    print "\n";

    read_enum("Video format", "FORMAT", "PAL", "NTSC");

    if ($config->{FORMAT} eq "NTSC")
    {
	read_bit("3:2 pulldown", "PULLDOWN");
	$config->{HEIGHT} = 480;
    }
    else
    {
	$config->{PULLDOWN} = 0;
	$config->{HEIGHT} = 576;
    }

    read_bit("Is source interlaced (tv) or not interlaced (film)", "INTERLACE");

    read_number("Audio bit rate in kbps", "AUDIO_RATE", $config->{MIN_AUDIO_RATE}, $config->{MAX_AUDIO_RATE});
    $config->{VIDEO_RATE} = int(($config->{DVD_SIZE}*8/1000) / $TOTAL_RUNNING_TIME - $config->{AUDIO_RATE});
    $config->{VIDEO_RATE} = $config->{MAX_VIDEO_RATE}
    if $config->{VIDEO_RATE} > $config->{MAX_VIDEO_RATE};
    read_number("Video bit rate in kbps", "VIDEO_RATE", $config->{MIN_VIDEO_RATE}, $config->{MAX_VIDEO_RATE});

    print "Encode: Video @ $config->{VIDEO_RATE} kbps audio @ $config->{AUDIO_RATE} kbps\n";

    #  4/3 = 1.333
    # 16/9 = 1.777
    # Average is 14/9 = 1.555
    # Choose aspect ratio and let user override

    if ($config->{IN_ASPECT} < 14/9)
    {
	# Choose 4:3
	$config->{ASPECT} = "4:3";
    }
    else
    {
	# Choose 16:9
	$config->{ASPECT} = "16:9";
    }
    read_enum("Aspect ratio of output", "ASPECT", "16:9", "4:3");
    my ($num, $den) = split /:/, $config->{ASPECT};
    $config->{ASPECT_RATIO} = $num/$den;
    
    # Ask user for width (default to width of video if it is a DVD width)
    my @widths = (720, 704, 352);
    $config->{WIDTH} = $config->{IN_WIDTH} if grep { $_ == $config->{IN_WIDTH} } @widths;
    read_enum("Width of output", "WIDTH", @widths);
    
    # calculate aspect ratio

    $config->{SCALE_WIDTH}  = $config->{WIDTH};
    $config->{SCALE_HEIGHT} = $config->{HEIGHT};

    print "Target aspect ratio is $config->{ASPECT} on $config->{WIDTH} x $config->{HEIGHT}\n";

    if ($config->{ASPECT_RATIO} <= $config->{IN_ASPECT}*(1-$config->{ACCEPTABLE_ASPECT_SKEW}/100))
    {
	print "Bar at the top/bottom - shrink the height\n";
	$config->{SCALE_HEIGHT} = 4*int($config->{SCALE_HEIGHT} * $config->{ASPECT_RATIO} / $config->{IN_ASPECT} / 4 + 0.5);
	$config->{YBAR} = ($config->{HEIGHT} - $config->{SCALE_HEIGHT}) / 2;
    }
    elsif ($config->{ASPECT_RATIO} >= $config->{IN_ASPECT}*(1+$config->{ACCEPTABLE_ASPECT_SKEW}/100))
    {
	print "Bar at the left/right - shrink the width\n";
	$config->{SCALE_WIDTH} = 4*int($config->{SCALE_WIDTH} / $config->{ASPECT_RATIO} * $config->{IN_ASPECT} / 4 + 0.5);
	$config->{XBAR} = ($config->{WIDTH} - $config->{SCALE_WIDTH}) / 2;
    }
    else
    {
	printf "No bar - %s (%.3f) is within %d%% of %.3f\n",
        $config->{ASPECT}, $config->{ASPECT_RATIO}, $config->{ACCEPTABLE_ASPECT_SKEW}, $config->{IN_ASPECT}
    }
    
    print "scale to $config->{SCALE_WIDTH}x$config->{SCALE_HEIGHT}\n";
    print "Top/bottom bars $config->{YBAR} pixels\n"
	if $config->{YBAR};
    print "Left/right bars $config->{XBAR} pixels\n"
	if $config->{XBAR};

    read_number("Chapters every how many minutes?", "CHAPTER_MINS", 1, 1000);
}

############################################################
# transcode the video using the settings already discovered
############################################################

sub transcode
{
    my @transcode_args = qw(transcode);
    my @yuvscaler_args;

    push @transcode_args, "-Z $config->{SCALE_WIDTH}x$config->{SCALE_HEIGHT}";
    push @yuvscaler_args, "-O SIZE_$config->{WIDTH}x$config->{HEIGHT}";
    
    if ($config->{XBAR} != 0 || $config->{YBAR} != 0)
    {
	print "Top/bottom bars $config->{YBAR} pixels, Left/right bars $config->{XBAR} pixels\n";
	push @transcode_args, sprintf("-Y %d,%d,%d,%d", -$config->{YBAR}, -$config->{XBAR}, -$config->{YBAR}, -$config->{XBAR});
	push @yuvscaler_args, "-M RATIO_$config->{IN_WIDTH}_$config->{SCALE_WIDTH}_$config->{IN_HEIGHT}_$config->{SCALE_HEIGHT}";
    }
    printf "Output is using %.3f Mpixels per visible picture frame\n",
    $config->{SCALE_WIDTH} * $config->{SCALE_HEIGHT} / 1E6;
    
    # Continue the command line
    my $aspect_code = $config->{ASPECT} eq "4:3" ? 2 : 3;
    my $format_code = $config->{FORMAT} eq "PAL" ? "p" : "n";
    my $mpeg2enc_opts = "-b $config->{VIDEO_RATE} -q 1 -I $config->{INTERLACE}";
    my $pulldown_opts = $config->{PULLDOWN} ? "-p" : "";
    
    push @transcode_args, "-V";
    push @transcode_args, "-y mpeg2enc,mp2enc -F 8,\"$mpeg2enc_opts\"";
    push @transcode_args, "-E 48000 -b $config->{AUDIO_RATE} -J resample";
    push @transcode_args, "--export_asr $aspect_code", 
    push @transcode_args, "--pulldown" if $config->{PULLDOWN};
    push @transcode_args, "-i '$config->{FILE}'";
    push @transcode_args, "-o '$config->{TEMP_DIR}/$config->{OUTPUT}'";
    
    # Work out the chapters for dvdauthor
    my @dvdauthor_args = qw(dvdauthor);
    my @chapters;
    for (my $t = 0; $t < $config->{RUNNING_TIME}; $t += 60*$config->{CHAPTER_MINS})
    {
	push @chapters, hms($t);
    }
    
    sys("mkdir -p '$config->{OUTPUT_DIR}/$config->{OUTPUT}'");
    
    if (1)
    {
	# Using mplayer/yuvscaler/mpeg2enc/mp2enc/mplex
	
	# Make a complicated pipeline using mplayer to decode the video and
	# clean it up (remove horizontal & vertical blocking artifacts,
	# dering, auto level and temporal noise filter) and resample the audio
	# to 48 kHz then encode the video and audio
	
	# FIXME the pipes are created in the current directory
	sys("rm -f stream.yuv stream.wav");
	sys("mkfifo stream.yuv stream.wav");
	sys(<<"#EOF");
mplayer -benchmark -noframedrop -af resample=48000:0:2 -ao pcm -aofile stream.wav -vo yuv4mpeg -vop pp=hb:c/vb:c/dr:c/al/tn:64:128:256 -osdlevel 0 '$config->{FILE}' </dev/null &
mp2enc -v 0 -r 48000 -b $config->{AUDIO_RATE} -s -o '$config->{TEMP_DIR}/$config->{OUTPUT}.mpa' < stream.wav &
yuvscaler -v 0 -n $format_code @yuvscaler_args < stream.yuv | mpeg2enc -v 0 -f 8 -F $config->{FRAMERATE_CODE} -n $format_code $pulldown_opts -a $aspect_code -o '$config->{TEMP_DIR}/$config->{OUTPUT}.m2v' $mpeg2enc_opts
#EOF
        sys("rm -f stream.yuv stream.wav");

	# Multiplex the audio and video
	sys("mplex -f 8 -o '$config->{TEMP_DIR}/$config->{OUTPUT}.part%d.vob' '$config->{TEMP_DIR}/$config->{OUTPUT}.m2v' '$config->{TEMP_DIR}/$config->{OUTPUT}.mpa'");
	
	# Remove the seperate streams
	sys("rm -f '$config->{TEMP_DIR}/$config->{OUTPUT}.m2v' '$config->{TEMP_DIR}/$config->{OUTPUT}.mpa'");
	
	# Concatenate the part vobs and remove them
	sys("cat '$config->{TEMP_DIR}/$config->{OUTPUT}.'part*.vob > '$config->{TEMP_DIR}/$config->{OUTPUT}.vob'");
	sys("rm -f '$config->{TEMP_DIR}/$config->{OUTPUT}.'part*.vob");
    }
    else
    {
	# Using transcode/mpeg2enc/mp2enc/tcmplex
	sys(join(" ", @transcode_args));
	
	sys("tcmplex -o '$config->{TEMP_DIR}/$config->{OUTPUT}.vob' -i '$config->{TEMP_DIR}/$config->{OUTPUT}.m2v' -p '$config->{TEMP_DIR}/$config->{OUTPUT}.mpa' -m d || /bin/true");
	# why tcmplex return 1 always? FIXME
	# can we check for something?
	
	sys("rm -f '$config->{TEMP_DIR}/$config->{OUTPUT}.m2v' '$config->{TEMP_DIR}/$config->{OUTPUT}.mpa'");
    }
    
    sys("dvdauthor -o '$config->{OUTPUT_DIR}/$config->{OUTPUT}' -v ". lc($config->{FORMAT}) ."  -c ". join(",", @chapters) ." '$config->{TEMP_DIR}/$config->{OUTPUT}.vob'");
    
    sys("rm -f '$config->{TEMP_DIR}/$config->{OUTPUT}.vob'");
}

############################################################
# Finalise the DVD structure
############################################################

sub finalise
{
    sys("dvdauthor -o '$config->{OUTPUT_DIR}/$config->{OUTPUT}' -T");
    print "DVD directory structure ready in '$config->{OUTPUT_DIR}/$config->{OUTPUT}'\n";
}

############################################################
# Convert seconds into hours mins and seconds
############################################################

sub hms
{
    my ($s) = @_;
    $s = int($s);
    my $m = int($s / 60);
    my $h = int($m / 60);
    $m = $m % 60;
    $s = $s % 60;
    return sprintf("%01d:%02d:%02d", $h, $m, $s);
}

############################################################
# Run a system command reporting errors
############################################################

sub sys
{
    my (@command) = @_;
    my $command = join " ", map { "'$_'" } @command;
    if ($DEBUG)
    {
        print "========================================\n";
        print "Not running: $command\n";
    }
    else
    {
        die "Command: $command failed: $?"
            if system(@command) != 0;
    }
}

############################################################
# Ask the user for an enumerated type
############################################################

sub read_enum
{
    my ($text, $name, @values) = @_;
    die "Couldn't find config value '$name'"
	unless defined $config->{$name};
    my $choice = 0;
    my $options = "";
    for (my $i = 0; $i < @values; $i++)
    {
	$options .= $config->{$name} eq $values[$i] ? " *" : "  ";
	$options .= "[" . ($i+1) . "] $values[$i]";
	if ($config->{$name} eq $values[$i])
	{
	    $options .= "*    <--- Default";
	    $choice = $i;
	}
	$options .= "\n";
    }
    while (1)
    {
	print "Choose $text or Enter for default $values[$choice]\n$options> ";
	my $in = "";
	chomp($in = <STDIN>) unless $YES;
	print "\n" if $YES;
	if ($in eq "")
	{
	    last;
	}
	elsif ($in !~ /^\d+$/)
	{
	    print "Numeric please!\n";
	}
	elsif ($in < 1 || $in > @values)
	{
	    print "In range 1..".scalar(@values)." please!\n";
	}
	else
	{
	    $config->{$name} = $values[$in - 1];
	    last;
	}
    }
}

############################################################
# Ask the user for a bit
############################################################

sub read_bit
{
    my ($text, $name) = @_;
    die "Couldn't find config value '$name'"
	unless defined $config->{$name};
    my @yorn = qw(No Yes);
    $config->{$name} = $yorn[$config->{$name}];
    read_enum($text, $name, @yorn);
    $config->{$name} = 0 if $config->{$name} eq $yorn[0];
    $config->{$name} = 1 if $config->{$name} eq $yorn[1];
}

############################################################
# Ask the user for a number
############################################################

sub read_number
{
    my ($text, $name, $min, $max) = @_;
    die "Couldn't find config value '$name'"
	unless defined $config->{$name};
    while (1)
    {
	print "Enter $text ($min..$max) or press Enter for $config->{$name} > ";
	my $in = "";
	chomp($in = <STDIN>) unless $YES;
	print "\n" if $YES;
	if ($in eq "")
	{
	    last;
	}
	elsif ($in !~ /^[0-9.]+$/)
	{
	    print "Numeric please!\n";
	}
	elsif ($in < $min || $in > $max)
	{
	    print "In range $min..$max please!\n";
	}
	else
	{
	    $config->{$name} = $in;
	    last;
	}
    }
}

############################################################
# Ask the user for a string
############################################################

sub read_string
{
    my ($text, $name) = @_;
    die "Couldn't find config value '$name'"
	unless defined $config->{$name};
    print "Enter $text or press Enter for '$config->{$name}' > ";
    my $in = "";
    chomp($in = <STDIN>) unless $YES;
    print "\n" if $YES;
    $config->{$name} = $in if $in ne "";
}
