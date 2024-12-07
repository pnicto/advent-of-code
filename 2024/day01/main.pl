use 5.010;
use strict;
use warnings;

use Data::Dump qw(dump);
use Path::Tiny;
use List::MoreUtils qw(zip);
use List::MoreUtils qw(frequency);
use autodie;

my $file  = path(".")->child("input.txt");
my $input = $file->slurp_utf8();

my @processed = split( /\n/, $input );

my @list1;
my @list2;

foreach my $pairs (@processed) {
    my @elements = split( /\s+/, $pairs );
    while (@elements) {
        push @list1, int( shift @elements );
        push @list2, int( shift @elements );
    }
}

@list1 = sort @list1;
@list2 = sort @list2;

# part 1
my $sum = 0;
foreach my ( $ele1, $ele2 ) ( zip @list1, @list2 ) {
    $sum += abs( $ele1 - $ele2 );
}
print "$sum\n";

# part 2
$sum = 0;
my %f = frequency(@list2);
foreach my $ele1 (@list1) {
    my $freq = $f{$ele1};
    if ($freq) {
        $sum += $ele1 * $freq;
    }
}
print "$sum\n";
