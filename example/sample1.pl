#!/usr/bin/env perl
use strict;
use warnings;
use FindBin::libs;

use Algorithm::SuffixArray;

while(<STDIN>){
    chomp;
    my $str = $_;
    my $sa = Algorithm::SuffixArray::SA_IS($str);
    for (my $i = 0; $i < @$sa; $i++) {
        printf "sa[%9d] = %3d, substr(str, %9d) = %s\n", $i, $sa->[$i], $sa->[$i], substr($str, $sa->[$i]);
    }
}
