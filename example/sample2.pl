#!/usr/bin/env perl
use strict;
use warnings;
use FindBin::libs;

use Algorithm::SuffixArray;

while(<STDIN>){
    chomp;
    my $str = $_;
    my @s = split '', $str;
    @s = map { ord } @s;
    push @s, 0;
    my $n = scalar @s;
    my $sa = [(0) x $n];
    Algorithm::SuffixArray::SA_IS2([@s], $sa, $n, 255, 0);
    for (my $i = 0; $i < @$sa; $i++) {
        printf "sa[%9d] = %3d, substr(str, %9d) = %s\n", $i, $sa->[$i], $sa->[$i], substr($str, $sa->[$i]);
    }
}
