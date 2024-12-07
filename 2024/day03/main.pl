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
my @input = split( /\n/, $input );

my $sum     = 0;
my @matches = $input =~ /mul\(\d{0,3},\d{0,3}\)/g;
for my $match (@matches) {
    my ( $a, $b ) = $match =~ /(\d+)/g;
    $sum = $sum + $a * $b;
}
say "part1: $sum";

my $index   = 0;
my $n       = length($input);
my $enabled = 1;
$sum = 0;

while ( $index < $n ) {
    if ( substr( $input, $index, 7 ) eq "don't()" ) {
        $enabled = 0;
        $index   = $index + 7;
    }
    elsif ( substr( $input, $index, 4 ) eq "do()" ) {
        $enabled = 1;
        $index   = $index + 4;
    }
    elsif ( substr( $input, $index, 4 ) eq "mul(" ) {
        my $match = substr( $input, $index, 13 ) =~ /mul\(\d{0,3},\d{0,3}\)/;
        if ($match) {
            my ( $a, $b ) = $& =~ /(\d+)/g;
            $sum   = $sum + $a * $b if $enabled;
            $index = $index + length($&);
        }
        else {
            $index = $index + 1;
        }
    }
    else {
        $index = $index + 1;
    }
}
say "part2: $sum";
