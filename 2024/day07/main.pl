use 5.010;
use strict;
use warnings;

use Data::Dump qw(dump);
use Path::Tiny;
use autodie;

my $file = path(".")->child("input.txt");
my $input = $file->slurp_utf8();
my @input = split(/\n/, $input);

while (my ($index, $test) = each @input) {
  my @parts = split(/: /, $test);
  my @nums = split(/ /, $parts[1]);
  @input[$index] = [$parts[0], $#nums+1, [@nums]];
}

sub is_valid_test {
  my ($target, $size, @nums) = @_;
  return 1 if $size == 1 && $nums[0] == $target;
  return check_target($target, 0, 0, $size, @nums);
}

sub check_target{
  my ($target, $current_result, $index, $size, @nums) = @_;

  if ($index == $size) {
    return $current_result == $target;
  }

  # WHY???????
  my $num = $nums[0][$index];
  my $summ = 0;
  my $multi = 0;

  $summ = (check_target($target, $current_result + $num, $index+1, $size, @nums));
  if ($index == 0) {
    $multi = (check_target($target, $num, $index + 1, $size, @nums));
  } else {
    $multi = (check_target($target, $current_result * $num, $index + 1, $size, @nums));
  }

  return $summ == 1 || $multi == 1;
}

my $part1 = 0;
for my $test (@input) {
  my $target = $test->[0];
  my $size = $test->[1];
  my @nums = $test->[2];

  if (is_valid_test($target, $size, @nums)) {
    $part1 += $target;
  }
}
say "Part 1: $part1";

sub is_valid_t {
  my ($target, $size, @nums) = @_;
  return 1 if $size == 1 && $nums[0] == $target;
  return check_target2($target, 0, 0, $size, @nums);
}

sub check_target2{
  my ($target, $current_result, $index, $size, @nums) = @_;

  if ($index == $size) {
    return $current_result == $target;
  }

  # WHY???????
  my $num = $nums[0][$index];
  my $summ = 0;
  my $multi = 0;
  my $concat = 0;

  $summ = (check_target2($target, $current_result + $num, $index+1, $size, @nums));
  if ($index == 0) {
    $multi = (check_target2($target, $num, $index + 1, $size, @nums));
  } else {
    $multi = (check_target2($target, $current_result * $num, $index + 1, $size, @nums));
  }
  $concat = (check_target2($target, $current_result . $num, $index + 1, $size, @nums));

  return $summ == 1 || $multi == 1 || $concat == 1;
}

my $part2 = 0;
for my $test (@input) {
  my $target = $test->[0];
  my $size = $test->[1];
  my @nums = $test->[2];
  if (is_valid_t($target, $size, @nums)) {
    $part2 += $target;
  }
}
say "Part 2: $part2";
