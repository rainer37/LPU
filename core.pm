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

# get number in string format.
sub get_numbers_reg {
    open FD_3D, '<', shift;
    my @n;
    while (<FD_3D>) {
        chomp;
        #my @num = split /\s/, $_;
        push @n, $_;
    }
    \@n;
}

# params: 	$n, ref of data array, $i, bsg index [0-2]
#			$bb, $ss, $gg are target digits to be matched.
# finding all the occurrence in the history that matched the target digits.
sub get_cell {
    my ($n, $i, $bb, $ss, $gg) = @_;
    my @nn = @{$n}; # de-ref to @nn
    my $data_len = @nn;
	#print "$bb:$s:$g:$data_len\n";
	my @m;
	for (my $j=0;$j<$data_len-5;$j++) {
		# print "$i $j $b $nn[$j][$i]\n";
		if ($bb == $nn[$j][$i] && $ss == $nn[$j+1][$i] && $gg == $nn[$j+2][$i]) {
			# print "match\n";
			my $abc_sum = ( $nn[$j+3][$i] + $nn[$j+4][$i] + $nn[$j+5][$i] ) % 8;
			my $def_sum = ( $nn[$j-1][0] + $nn[$j-1][1] + $nn[$j-1][2] ) % 8;
			my $all_sum = ( $abc_sum + $def_sum ) % 8;
			# print "$abc_sum\n";
			my @s = split //, "$bb$ss$gg$abc_sum$nn[$j+3][$i]$nn[$j+4][$i]$nn[$j+5][$i]".
                                "$def_sum$nn[$j-1][0]$nn[$j-1][1]$nn[$j-1][2]$all_sum\n";
			print @s;
			push @m, \@s;
		}
	}
	#}
	#print $m[0][6];
	@m;
}

# format matched result to the same as regular match.
# params: @str, matched string, $bsg, target.
sub format_match {
    my $bsg = pop @_;
    my @str = @_;
    my @m;
    for (@m = split "a", (join "", @str)) {
        $_ = $bsg.substr($_, 3, 3).substr($_, 0, 3)."\n";
    }
    @m;
}

# get matching cells with regex.
# params: $n, data array, $bsg, target.
sub get_cell_reg {
    my ($n, $bb, $ss, $gg) = @_;
    my @nn = @{$n};
    my $str = join "\n", @{nn};
    my $bsg = $bb.$ss.$gg;
    my @m;
    $str =~ s/\n/a/g; # replace \n to a;
    $str =~ s/\s//g;  # remove whitespace;
    my @ss = $str =~ /a(\d)(\d)(\d)a$bb\d\da$ss\d\da$gg\d\da(\d)\d\da(\d)\d\da(\d)\d\d(a)/g;
    push @m, format_match @ss, $bsg;
    @ss = $str =~ /a(\d)(\d)(\d)a\d$bb\da\d$ss\da\d$gg\da\d(\d)\da\d(\d)\da\d(\d)\d(a)/g;
    push @m, format_match @ss, $bsg;
    @ss = $str =~ /a(\d)(\d)(\d)a\d\d${bb}a\d\d${ss}a\d\d${gg}a\d\d(\d)a\d\d(\d)a\d\d(\d)(a)/g;
    push @m, format_match @ss, $bsg;
    # print @m;
    \@m;
}

# params: 	$nn, reference of data array.
#			$target, target to find.
# finding the matching patterns in data array
# specified by target. 
sub base_compute {
	my ($nn, @bsg) = @_;
    my %r; # hash of reference of matching results.
    $r{"B"} = get_cell_reg $nn, @bsg[0..2];
    $r{"S"} = get_cell_reg $nn, @bsg[3..5];
    $r{"G"} = get_cell_reg $nn, @bsg[6..8];
    %r;
}

# computation routing dispatcher.
sub compute {
	my $id = shift;
	my @nine = split //, get_nine shift;
	# print "id: $id nine: @nine[0..2]\n";
	my $nn = get_numbers_reg $Util::FILE_3D;
    # my $s1 = @nn;

	if ($id == 0) {
        my %r = base_compute $nn, @nine;
        print $r{"B"}[1];
	} else {
		&feature_BSG;
	}
}

sub feature_BSG {
	666;
}

1;