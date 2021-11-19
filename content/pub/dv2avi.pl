#!/usr/bin/perl -w
#
# Convert the input raw dv file into a testdata.raw file for dvgrab
# then run dvgrab on it to convert it to avi then delete the
# testdata.raw file

use strict;
$|++;

my ($input) = @ARGV;
die "Syntax: $0 <file.dv>" unless @ARGV == 1 && $input =~ /^(.*)\.dv$/;
my $name = $1;
my $output = "testdata.raw";
my $mark_interval = 1024*1024;
my $pad = pack("ix12", 492);


open(IN, "<$input") or die "Failed to open $input: $!";
open(OUT, ">$output") or die "Failed to open $output: $!";

print "Converting $input -> $output";
my $mark = 0;
my $frames = 0;
while (1)
{
    my $buffer;
    my $bytes = read(IN, $buffer, 480);
    die "Error reading: $!" unless defined $bytes;
    last if $bytes == 0;
    die "Bad blocking $bytes != 480" unless $bytes == 480;

    $frames++ if $buffer =~ /^\x1f\x07/;

    print OUT $pad, $buffer;
    if (($mark -= $bytes) < 0)
    {
	print ".";
	$mark += $mark_interval;
    }
}
print OUT pack("i", -1);	# -1 length packet on the end
print "Done\n";
print "Read $frames frames\n";
my $oframes = $frames-2;

close(OUT) or die "Failed to close $output: $!";
close(IN) or die "Failed to close $input: $!";

print "Converting $output -> ${name}001.avi\n";
system("dvgrab", "--frames", $oframes, "--format", "dv2", "--testmode", $name) == 0
    or warn "dvgrab failed with error code: $?";
print "Done\n";

print "Deleting temp file $output...";
unlink("$output") or die "Failed to delete temporary file $output";
print "Done\n";

rename("${name}001.avi", "$name.avi") or warn "Couldn't rename ${name}001.avi $name.avi: $!";

print "Written $oframes frames into $name.avi\n";
