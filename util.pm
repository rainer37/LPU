use strict;
use warnings;
package Util;
# chop last char of str.

our $URL_3D = 'https://kaijiang.500.com/sd.shtml';
our $URL_PLS = 'https://kaijiang.500.com/pls.shtml';
our $FILE_3D = 'data/numbers.txt';
our $FILE_PLS = 'data/n.txt';

sub chop_last {
	my $str = reverse shift;
	chop $str && reverse $str;
}

1;

# 123 845 336
# 123 833 716
# 123 121 348
# 123 020 706
# 123 260 339
# 123 240 711
# 123 758 831
# 123 611 823

# 123 335 039
# 123 534 667
# 123 626 038
# 123 155 088

# 123 936 513
# 123 650 817
# 123 813 414
# 123 967 549
# 123 308 368
# 123 654 724
# 123 703 827
# 123 726 057