use 5.010;
use strict;
use warnings;

use Data::Dump qw(dump);
use Path::Tiny;
use List::MoreUtils qw(zip);
use List::MoreUtils qw(frequency);
use autodie;

my $file = path(".")->child("input.txt");
my $input = $file->slurp_utf8();
my @input = split(/\n/, $input);

my $sum = 0;
my @matches = $input =~ /mul\(\d{0,3},\d{0,3}\)/g;
for my $match (@matches) {
  my ($a, $b) = $match =~ /(\d+)/g;
  $sum = $sum + $a * $b;
}
say "part1: $sum";

