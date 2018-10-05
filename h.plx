#!/usr/bin/perl

{
package HWebServer;

use utf8;
use base qw(HTTP::Server::Simple::CGI);
use Util qw(chop_last);
use Core qw(compute);

my $FORMAT_ERR_MSG = qw#Wrong format: [1-9]{9}[a|b|ab|ba|aa|bb]#;
my %dispatch = (
	'/hello' => \&resp_hello,
);

sub http_print {
	my ($cgi, $status, $head, $content) = @_;
	print "HTTP/1.0 " . ($status == 2 ? "200 OK" : "404 Not found") . "\r\n";
	print 	$cgi->header,
	$cgi->start_html($head),
	$cgi->h1($content),
	$cgi->end_html;
}

sub path_guard {
	my $path = $_[0];
	my $routine_id = -1;
 	if ($path =~ /^[1-9]{9}[ab]{1,2}$/) {
 		if ($path =~ /(aa)$/) {
 			$routine_id = 2;
 		} elsif ($path =~ /(ba)$/) {
 			$routine_id = 5;
 		} elsif ($path =~ /(ab)$/) {
 			$routine_id = 4;
 		} elsif ($path =~ /(bb)$/) {
 			$routine_id = 3;
 		} elsif ($path =~ /(a)$/) {
 			$routine_id = 0;
 		} elsif ($path =~ /(b)$/) {
 			$routine_id = 1;
 		}
 	}
 	$routine_id; 
}

sub handle_request {
	my ($self, $cgi) = @_;

    my $path = Util::chop_last $cgi->path_info; # get path without '/'

 	my $routine_id = path_guard $path;
 	if ($routine_id == -1) {
 		# $handler = \&resp_hello;
 		$handler = \&not_found;
 	} else {
 		$handler = \&pure_9_digits;
 	}

 	$handler->($cgi, $routine_id);
}

sub resp_hello {
	my $cgi = shift;
	return if !ref $cgi;
	my $who = $cgi->param('name');
	http_print ($cgi, 2, "Hello", "Hello $who");
}

sub not_found {
	my $cgi = shift;
	return if !ref $cgi;
	http_print ($cgi, 4, "Not found", $FORMAT_ERR_MSG);
	1;
}

sub pure_9_digits {
	my $cgi = shift;
	return if !ref $cgi;
	my $id = shift;
	my $result = Core::compute $id;
	my $path = $cgi->path_info;
	http_print ($cgi, 2, $path, $result);
}
}

my $pid = HWebServer->new(8080)->run();