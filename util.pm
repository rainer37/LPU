package Util;
# chop last char of str.
sub chop_last {
	my $str = $_[0];
	$str = reverse $str;
	chop $str;
	reverse $str;
}

1;