package Core;
use strict;
use warnings;
use Grabber;

# cell identifier.
our ($BB, $BS, $BG, $SB, $SS, $SG, $GB, $GS, $GG) = (0..8);
# get nine digits.
sub get_nine {
	substr shift, 0, 9 
}

# read data from data file.
# load it to an 2D array.
sub get_numbers {
	open FD_3D, '<', shift;
	my @n;
	while (<FD_3D>) {
		chomp;
		my @num = split /\s/, $_;
		push @n, \@num; 
	}
	\@n;
}

sub get_cell {
    my ($n, $i, $bb, $s, $g) = @_;
    my @nn = @{$n}; # de-ref to @nn
    my $data_len = @nn;
	#print "$bb:$s:$g:$data_len\n";
	my @m;
	for (my $j=0;$j<$data_len-5;$j++) {
		# print "$i $j $b $nn[$j][$i]\n";
		if ($bb == $nn[$j][$i] && $s == $nn[$j+1][$i] && $g == $nn[$j+2][$i]) {
			# print "match\n";
			my $abc_sum = ( $nn[$j+3][$i] + $nn[$j+4][$i] + $nn[$j+5][$i] ) % 8;
			my $def_sum = ( $nn[$j-1][0] + $nn[$j-1][1] + $nn[$j-1][2] ) % 8;
			my $all_sum = ( $abc_sum + $def_sum ) % 8;
			# print "$abc_sum\n";
			my @s = split //, "$bb$s$g$abc_sum$nn[$j+3][$i]$nn[$j+4][$i]$nn[$j+5][$i]".
                                "$def_sum$nn[$j-1][0]$nn[$j-1][1]$nn[$j-1][2]$all_sum\n";
			print @s;
			push @m, \@s;
		}
	}
	#}
	#print $m[0][6];
	@m;
}

# params:   $n, ref of nn array
#           $i, $j indices in array
sub find_match {
    my @nn = @{shift};
    my ($i, $j) = @_;
    # print "$i $j $b $nn[$j][$i]\n";
    if ($bb == $nn[$j][$i] && $s == $nn[$j+1][$i] && $g == $nn[$j+2][$i]) {
        # print "match\n";
        my $abc_sum = ( $nn[$j+3][$i] + $nn[$j+4][$i] + $nn[$j+5][$i] ) % 8;
        my $def_sum = ( $nn[$j-1][0] + $nn[$j-1][1] + $nn[$j-1][2] ) % 8;
        my $all_sum = ( $abc_sum + $def_sum ) % 8;
        # print "$abc_sum\n";
        my @s = split //, "$bb$s$g$abc_sum$nn[$j+3][$i]$nn[$j+4][$i]$nn[$j+5][$i]".
            "$def_sum$nn[$j-1][0]$nn[$j-1][1]$nn[$j-1][2]$all_sum\n";
        print @s;
        push @m, \@s;
    }
}

# params: 	$nn, reference of data array.
#			$target, target to find.
# finding the matching patterns in data array
# specified by target. 
sub base_compute {
	my ($nn, @bsg) = @_;
    # print "$bb, $ss, $gg, ${@$nn[0]}[2]\n";
	my @one = get_cell $nn, $BB, @bsg;
	print "Test: $one[0][4]\n";
	#get_cell $nn, $BS, $b, $s, $g;
	#get_cell $nn, $BG, $b, $s, $g;
}

# computation routing dispatcher.
sub compute {
	my $id = shift;
	my @nine = split //, get_nine shift;
	# print "id: $id nine: @nine[0..2]\n";
	my $nn = get_numbers $Grabber::FILE_3D;
    # my $s1 = @nn;
    # print "$s1 \n";
	print $nn."\n";

	if ($id == 0) {
		base_compute $nn, @nine[0..2];
	} else {
		&feature_BSG;
	}
}

sub feature_BSG {
	666;
}

1;