package Grabber;
use strict;
use warnings;
use Schedule::Cron;
use LWP::UserAgent ();
use Path::Tiny;
use Util;

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

sub schedule_update {
	my $cron = new Schedule::Cron(\&grab);
	$cron->add_entry("*/1 * * * *");
	$cron->run(nofork=>1);
}

# param: all html.
# grab three numbers, marked by "ball_orange".
sub grab_balls {
	(join "", shift =~ /ball_orange">.*/mg) =~ /(\d).*(\d).*(\d)/;
}

# param: user_agent, url
# grab the html content.
sub grab_html {
	shift->get(shift)->decoded_content;
}

# param: balls, file_name
# write balls to disk. Prepend to the file.
sub write_balls {
	my $str = shift;
	my $filename = shift;
	my $content = path($filename)->slurp_utf8;;
	path($filename)->spew_utf8($str."\n", $content);
}

sub grab_routine {
	my @balls = grab_balls (grab_html shift, shift);
	write_balls (join (" ", @balls), shift);
}

sub grab {
	print "grabbing...\n";
	my $ua = LWP::UserAgent->new;
	# update 3D
	grab_routine $ua, $Util::URL_3D, $Util::FILE_3D;
	# update pai lie san
	grab_routine $ua, $Util::URL_PLS, $Util::FILE_PLS;
}

1;