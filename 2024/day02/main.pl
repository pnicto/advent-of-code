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


my $count = 0;

# part 1
foreach my $line (@input) {
  my @numbers = split(/ /, $line);

  my $increasing = is_increasing(\@numbers);
  my $decreasing = is_decreasing(\@numbers);

  if ($increasing or $decreasing) {
    $count++;
  }
}

print "part 1: $count\n";

sub is_increasing {
  my ( $numbers_ref ) = @_;
  for (my $i = 1; $i <= $#{$numbers_ref}; $i++) {
    my $diff = ${$numbers_ref}[$i] - ${$numbers_ref}[$i - 1];
    if (${$numbers_ref}[$i] < ${$numbers_ref}[$i - 1]) {
      return 0;
    } elsif ($diff > 3 or $diff < 1){
      return 0;
    }
  }
  return 1;
}

sub is_decreasing {
  my ( $numbers_ref ) = @_;
  for (my $i = 1; $i <= $#{$numbers_ref}; $i++) {
    my $diff = ${$numbers_ref}[$i - 1] - ${$numbers_ref}[$i];
    if (${$numbers_ref}[$i] > ${$numbers_ref}[$i - 1]) {
      return 0;
    } elsif ($diff > 3 or $diff < 1){
      return 0;
    }
  }
  return 1;
}
