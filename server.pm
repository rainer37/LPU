package Server;

use strict;
use warnings;
use utf8;
use base qw(HTTP::Server::Simple::CGI);
use Util qw(chop_last);
use Core qw(compute);

our $FORMAT_ERR_MSG = "Wrong format: [1-9]{9}[a|b|ab|ba|aa|bb]";

# generic http response output.
sub http_print {
	my ($cgi, $status, $head, $content) = @_;
	print "HTTP/1.0 ".($status == 2?"200 OK":"404 Not found")."\r\n";
	print 	$cgi->header,
	$cgi->start_html($head),
	$cgi->h1($content),
	$cgi->end_html;
}

# check input url, and return id indicating which computing routine.
sub path_guard {
	my $path = shift;
	my $routine_id = -1;
 	if ($path =~ /^[0-9]{9}[ab]{1,2}$/) {
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

# request dispatcher.
sub handle_request {
	my ($self, $cgi) = @_;
    my $path = Util::chop_last $cgi->path_info; # get path without '/'
 	my $routine_id = path_guard $path;

 	my $handler = $routine_id == -1 ? \&not_found : \&normal;

 	# execute handler function.
 	$handler->($cgi, $routine_id);
}

sub not_found {
	return if !ref (my $cgi = shift);
	http_print ($cgi, 4, "Not found", $FORMAT_ERR_MSG);1;
}

sub normal {
	return if !ref (my $cgi = shift);
	my $id = shift;
	my $path = Util::chop_last $cgi->path_info;
	my $result = Core::compute $id, $path;
	http_print ($cgi, 2, $path, $result);
}

# server run wrapper. 
sub server_run {
	my $pid = Server->new(8080)->run();
}
1;