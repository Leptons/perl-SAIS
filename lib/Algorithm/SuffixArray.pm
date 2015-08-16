package Algorithm::SuffixArray;
use strict;
use warnings;

use Data::Dumper;

my $_mask = [0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01];

sub _tget {
    my ($t, $i) = @_;

    return ($t->[int($i/8)]&$_mask->[$i%8]) ? 1 : 0;
}

sub _tset {
    my ($t, $i, $b) = @_;

    $t->[int($i/8)] = ($b ? $_mask->[$i%8]|$t->[int($i/8)] : (~$_mask->[$i%8])&$t->[int($i/8)]);
}

sub _isLMS {
    my ($t, $i) = @_;

    return $i>0 && _tget($t, $i) && !_tget($t, $i-1);
}

sub _ch {
    my ($s, $i) = @_;

    return $s->[$i];
}

sub _getBuckets {
    my ($s, $bkt, $n, $K, $end, $o) = @_;

    my $i;
    my $sum = 0;

    #$bkt = [ (0) x ($K+1) ];
    for($i = 0; $i <= $K; $i++){
        $bkt->[$i] = 0;
    }
    for($i = 0; $i < $n; $i++){
        $bkt->[_ch($s, $i+$o)]++;
    }
    for($i = 0; $i <= $K; $i++){
        $sum += $bkt->[$i];
        $bkt->[$i] = ($end ? $sum : $sum-$bkt->[$i]);
    }
}

sub _induceSAl {
    my ($t, $SA, $s, $bkt, $n, $K, $end, $o) = @_;

    my ($i, $j);
    _getBuckets($s, $bkt, $n, $K, $end, $o);
    for($i = 0; $i < $n; $i++){
         $j = $SA->[$i]-1;
        if($j >= 0 && !_tget($t, $j)) {
            $SA->[$bkt->[_ch($s, $j+$o)]++] = $j;
        }
    }
}

sub _induceSAs {
    my ($t, $SA, $s, $bkt, $n, $K, $end, $o) = @_;

    my ($i, $j);
    _getBuckets($s, $bkt, $n, $K, $end, $o);
    for($i = $n-1; $i >= 0; $i--){
        $j = $SA->[$i]-1;
        if($j >= 0 && _tget($t, $j)) {
            $SA->[--$bkt->[_ch($s, $j+$o)]] = $j;
        }
    }
}

# find the suffix array SA of s[0..n-1] in {1..K}^n
sub SA_IS2 {
    my ($s, $SA, $n, $K, $o) = @_;

    my ($i, $j);
    my $t = [ (0) x (int($n/8)+1) ];
    _tset($t, $n-2, 0);
    _tset($t, $n-1, 1);
    for($i = $n-3; $i >= 0; $i--){
        _tset($t, $i, (_ch($s, $i+$o) < _ch($s, $i+1+$o) || (_ch($s, $i+$o) == _ch($s, $i+1+$o) && _tget($t, $i+1) == 1)) ? 1 : 0);
    }

    # stage 1
    my $bkt = [ (0) x ($K+1) ];
    _getBuckets($s, $bkt, $n, $K, 1, $o);
    for($i = 0; $i < $n; $i++){
        $SA->[$i] = -1;
    }
    for($i = 1; $i < $n; $i++){
        if(_isLMS($t, $i)){
            $SA->[--$bkt->[_ch($s, $i+$o)]] = $i;
        }
    }
    _induceSAl($t, $SA, $s, $bkt, $n, $K, 0, $o);
    _induceSAs($t, $SA, $s, $bkt, $n, $K, 1, $o);

    my $n1 = 0;
    for($i = 0; $i < $n; $i++){
        if(_isLMS($t, $SA->[$i])){
            $SA->[$n1++] = $SA->[$i];
        }
    }

    for ($i = $n1; $i < $n; $i++){
        $SA->[$i] = -1;
    }
    my $name = 0;
    my $prev = -1;
    for($i = 0; $i < $n1; $i++){
        my $pos = $SA->[$i];
        my $diff = 0;
        for(my $d = 0; $d < $n; $d++){
            if($prev == -1 || _ch($s, $pos+$d+$o) != _ch($s, $prev+$d+$o) || _tget($t, $pos+$d) != _tget($t, $prev+$d)){
                $diff = 1;
                last;
            } elsif ($d > 0 && (_isLMS($t, $pos+$d) || _isLMS($t, $prev+$d))){
                last;
            }
        }

        if($diff) {
            $name++;
            $prev = $pos;
        }
        $pos = int(($pos%2 == 0) ? $pos/2 : ($pos-1)/2);
        $SA->[$n1+$pos] = $name-1;
    }
    for($i = $n-1, $j = $n-1; $i >= $n1; $i--){
        if($SA->[$i] >= 0){
            $SA->[$j--] = $SA->[$i];
        }
    }
    # stage 2
    my $SA1 = $SA;
    my $s1 = $SA;
    my $o1 = $n-$n1;
    if($name < $n1){
        SA_IS2($s1, $SA1, $n1, $name-1, $o1);
    } else {
        for($i = 0; $i < $n1; $i++){
            $SA1->[$s1->[$i+$o1]] = $i;
        }
    }

    # stage 3
    $bkt = [ (0) x ($K+1)] ;
    _getBuckets($s, $bkt, $n, $K, 1, $o);
    for($i = 1, $j = 0; $i < $n; $i++){
        if(_isLMS($t, $i)){
            $s1->[($j++)+$o1] = $i;
        }
    }
    for($i = 0; $i < $n1; $i++){
        $SA1->[$i] = $s1->[$SA1->[$i]+$o1];
    }
    for($i = $n1; $i < $n; $i++){
        $SA->[$i] = -1;
    }
    for($i = $n1-1; $i >= 0; $i--){
        $j = $SA->[$i];
        $SA->[$i] = -1;
        $SA->[--$bkt->[_ch($s, $j+$o)]] = $j;
    }
    _induceSAl($t, $SA, $s, $bkt, $n, $K, 0, $o);
    _induceSAs($t, $SA, $s, $bkt, $n, $K, 1, $o);
}

sub SA_IS {
    my @s = map { ord } split '', shift;
    push @s, 0;
    my $n = @s;
    my $SA = [(0) x $n];
    my $K = 255;
    SA_IS2([@s], $SA, $n, $K, 0);
    shift @$SA;
    return $SA;
}

1;
__END__
