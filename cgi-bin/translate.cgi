#!/usr/bin/perl -T

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use IO::Socket;

$ENV{PATH} = "/bin:/usr/bin";
$ENV{ENV} = "";

$query = new CGI;
$title = "Translate";

my $url = $query->param('url');

if ($url eq "")
{
	# we haven't been run before so output this page
	print $query->header;
	print $query->start_html($title);
	print "<H1>$title</H1>\n";
	print "Welcome to $title<BR>Please enter a URL<P>";
	print $query->textfield(-name => 'url', -size => 512, -value => 'http://www.');
	print $query->submit();
	print $query->end_html;
# -name => undef, value => 'Press this button when you have entered the URL');
}
else
{
	# fetch the page from squid running on this machine
	my $remote = IO::Socket::INET->new( Proto     => 'tcp',
					    PeerAddr  => 'localhost',
					    PeerPort  => '3128',
					  );
	unless ($remote) { die "Cannot connect to http daemon to get $url" }
	$remote->autoflush(1);
#	print "Content-Type: text/plain\n\n";
	print $remote "GET $url HTTP/1.0\n\n";
	$reply = <$remote>;
	while ( <$remote> )
	{
		print;
	}
	close $remote;
	print "\n<-- $url fetched by $title: $reply -->\n"
}
