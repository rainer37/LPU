#!/usr/bin/perl
use strict;
use warnings;
use Grabber qw(grab);
use Server qw(server_run);
use Core qw(compute);

# start data updater.
# schedule_update;
# start http server.
#my $pid = Server::server_run();
Core::compute 0, '123445555a';