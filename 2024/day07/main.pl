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
  @input[$index] = [$parts[0], [@nums]];
}

sub is_valid_test {
  my ($target, $nums, $is_part1) = @_;
  return 1 if @$nums == 1 && $nums->[0] == $target;
  return check_target($target, 0, 0, $nums, $is_part1);
}

sub check_target{
  my ($target, $current_result, $index, $nums, $is_part1) = @_;

  if ($index == @$nums) {
    return $current_result == $target;
  }

  my $num = $nums->[$index];
  my $summ = 0;
  my $multi = 0;
  my $concat = 0;

  $summ = check_target($target, $current_result + $num, $index+1, $nums, $is_part1);
  if ($index == 0) {
    $multi = check_target($target, $num, $index + 1, $nums, $is_part1);
  } else {
    $multi = check_target($target, $current_result * $num, $index + 1, $nums, $is_part1);
  }
  if ($is_part1) {
    $concat = check_target($target, $current_result . $num, $index + 1, $nums, $is_part1);
  }

  return $summ == 1 || $multi == 1 || $concat == 1;
}

my $part1 = 0;
for my $test (@input) {
  my $target = $test->[0];
  my $nums = $test->[1];

  if (is_valid_test($target, $nums)) {
    $part1 += $target;
  }
}
say "Part 1: $part1";

my $part2 = 0;
for my $test (@input) {
  my $target = $test->[0];
  my $nums = $test->[1];

  if (is_valid_test($target, $nums, 1)) {
    $part2 += $target;
  }
}
say "Part 2: $part2";
