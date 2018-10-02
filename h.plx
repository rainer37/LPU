#!/usr/bin/perl

{
package HWebServer;

use HTTP::Server::Simple::CGI;
use base qw(HTTP::Server::Simple::CGI);

my %dispatch = (
	'/hello' => \&resp_hello,
);

sub handle_request {
	my ($self, $cgi) = @_;

    my $path = $cgi->path_info();
    my $handler = $dispatch{$path};
 
    if (ref($handler) eq "CODE") {
        print "HTTP/1.0 200 OK\r\n";
        $handler->($cgi);
         
    } else {
        print "HTTP/1.0 404 Not found\r\n";
        print $cgi->header,
              $cgi->start_html('Not found'),
              $cgi->h1('Not found'),
              $cgi->end_html;
    }
}

sub resp_hello {
	my $cgi = shift;
	return if !ref $cgi;

	my $who = $cgi->param('name');

	print 	$cgi->header,
			$cgi->start_html("Hello"),
			$cgi->h1("Hello $who"),
			$cgi->end_html;
}
}

my $pid = HWebServer->new(8080)->run();