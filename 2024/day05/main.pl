use 5.010;
use strict;
use warnings;

use Data::Dump qw(dump);
use Path::Tiny;
use autodie;

my $file = path(".")->child("input.txt");
my $input = $file->slurp_utf8();
my ($rules, $updates) = split(/\n\n/, $input);

# input parsing
my @rules = split(/\n/, $rules);
@rules = map { [split(/\|/, $_)] } @rules;
my @updates = split(/\n/, $updates);
@updates = map { [split(/,/, $_)] } @updates;

#dump @rules;
#dump @updates;

# mark all rules in a hash
my %rules_hash;
for my $rule (@rules) {
    my $id = $rule->[1];
    if (exists $rules_hash{$id}) {
      push @{$rules_hash{$id}}, $rule->[0];
    } else {
      $rules_hash{$id} = [$rule->[0]];
    }
}
#dump \%rules_hash;

my @valid_updates;

for my $update (@updates) {
  my %available_rules;
  while (my ($i, $page) = each @$update) {
    $available_rules{$page} = $i;
  }
  #dump \%available_rules;

  my $is_valid = 1;

  while (my ($i, $page) = each @$update) {
    for my $required_page (@{$rules_hash{$page}}) {
      if (exists $available_rules{$required_page} && $available_rules{$required_page} > $i) {
        $is_valid = 0;
        last;
      }
    }
  }

  if ($is_valid) {
    push @valid_updates, $update;
  }
}

#dump @valid_updates;

my $part1 = 0;
for my $update (@valid_updates) {
  my $count = int(@$update / 2);
  $part1 += @$update[$count];
}

say "Part 1: $part1";
