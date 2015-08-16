use strict;
use warnings;
use lib 't/lib';

use Test::More;

use Test::SuffixArray;

use_ok 'Algorithm::SuffixArray';

subtest 'zero' => sub {
    my $s = '';
    my $sa = Algorithm::SuffixArray::SA_IS($s);
    my $sa2 = Test::SuffixArray::SA($s);
    is_deeply $sa, [];
    is_deeply $sa, $sa2;
};

subtest 'one' => sub {
    my $s = 'a';
    my $sa = Algorithm::SuffixArray::SA_IS($s);
    my $sa2 = Test::SuffixArray::SA($s);
    is_deeply $sa, [0];
    is_deeply $sa, $sa2;
};

subtest 'abc' => sub {
    my $s = 'abc';
    my $sa = Algorithm::SuffixArray::SA_IS($s);
    my $sa2 = Test::SuffixArray::SA($s);
    is_deeply $sa, [0, 1, 2];
    is_deeply $sa, $sa2;
};

subtest 'cab' => sub {
    my $s = 'cab';
    my $sa = Algorithm::SuffixArray::SA_IS($s);
    my $sa2 = Test::SuffixArray::SA($s);
    is_deeply $sa, [1, 2, 0];
    is_deeply $sa, $sa2;
};

subtest 'basic' => sub {
    my $s = 'tabatadebatabata';
    my $sa = Algorithm::SuffixArray::SA_IS($s);
    my $sa2 = Test::SuffixArray::SA($s);
    is_deeply $sa, [15, 11, 1, 5, 13, 9, 3, 12, 8, 2, 6, 7, 14, 10, 0, 4,];
    is_deeply $sa, $sa2;
};

subtest 'basic2' => sub {
    my $s = 'aaaabbbbcdefhaadfacneiadnfadceinafdidnfaddifanaidnfiadnfaiddd0ds';
    my $sa = Algorithm::SuffixArray::SA_IS($s);
    my $sa2 = Test::SuffixArray::SA($s);
    is_deeply $sa, $sa2;
};

subtest 'basic3' => sub {
    my $s = 'akasakasakasu';
    my $sa = Algorithm::SuffixArray::SA_IS($s);
    my $sa2 = Test::SuffixArray::SA($s);
    is_deeply $sa, $sa2;
};

done_testing();
