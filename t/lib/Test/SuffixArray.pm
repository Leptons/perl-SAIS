package Test::SuffixArray;
use strict;
use warnings;

sub SA ($) {
    my $str = shift;
    my $len = length $str;
    my @SA;
    my %h;
    for(my $i = 0; $i < $len; $i++){
        $h{substr $str, $i} = $i;
    }
    my @keys = sort keys %h;
    for(my $i = 0; $i < $len; $i++){
        push @SA, $h{$keys[$i]};
    }
    return \@SA;
}

1;
__END__
