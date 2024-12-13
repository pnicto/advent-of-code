use 5.010;
use strict;
use warnings;

use Data::Dump qw(dump);
use Path::Tiny qw(path);
use autodie;

my $file = $ARGV[0];
if ( not defined $file ) {
    say "Using default as sample.txt";
    $file = "sample.txt";
}

my $input          = path($file)->slurp;
my @config_strings = split( /\n\n/, $input );

my @buttonA;
my @buttonB;
my @prizes;

my $cost_a     = 3;
my $cost_b     = 1;
my $num_prizes = @config_strings;

for my $config_string (@config_strings) {
    my ( $a_string, $b_string, $prize_string ) = split( /\n/, $config_string );

    # get the required values
    my @parts = split( /: /, $a_string );
    my $part  = $parts[1];
    @parts = split( /, /, $part );
    push @buttonA, [ substr( $parts[0], 2 ), substr( $parts[1], 2 ) ];

    @parts = split( /: /, $b_string );
    $part  = $parts[1];
    @parts = split( /, /, $part );
    push @buttonB, [ substr( $parts[0], 2 ), substr( $parts[1], 2 ) ];

    @parts = split( /: /, $prize_string );
    $part  = $parts[1];
    @parts = split( /, /, $part );
    push @prizes, [ substr( $parts[0], 2 ), substr( $parts[1], 2 ) ];
}

sub part1 {
    my ( $buttonA, $buttonB, $prizes, $cost_a, $cost_b, $num_prizes ) = @_;

    my $part1 = 0;
    for my $i ( 0 .. $num_prizes - 1 ) {
        my $cost = -1;
        for my $contri_a ( 1 .. 100 ) {
            for my $contri_b ( 1 .. 100 ) {
                my $x =
                  $buttonA->[$i][0] * $contri_a + $buttonB->[$i][0] * $contri_b;
                my $y =
                  $buttonA->[$i][1] * $contri_a + $buttonB->[$i][1] * $contri_b;
                if ( $x == $prizes->[$i][0] && $y == $prizes->[$i][1] ) {
                    my $new_cost = $cost_a * $contri_a + $cost_b * $contri_b;
                    if ( $cost == -1 || $new_cost < $cost ) {
                        $cost = $new_cost;
                    }
                }
            }
        }

        if ( $cost > 0 ) {
            $part1 += $cost;
        }
    }
    say "part1: $part1";
}
part1( \@buttonA, \@buttonB, \@prizes, $cost_a, $cost_b, $num_prizes );

sub part2 {
    my ( $buttonA, $buttonB, $prizes, $cost_a, $cost_b, $num_prizes ) = @_;

    my $part2 = 0;
    for my $i ( 0 .. $num_prizes - 1 ) {
        $prizes->[$i][0] += 10000000000000;
        $prizes->[$i][1] += 10000000000000;

# :clown: I knew the part2 would have a number > 100
# this is the solution of 2 linear equations got from the part1 example equations
# 94*x + 22*y = 84000
# 34*x + 67*y = 5400
# contri_b is the value of y after solving the above equation and making it more generic
        my $contri_b =
          ( $prizes->[$i][0] * $buttonA->[$i][1] -
              $prizes->[$i][1] * $buttonA->[$i][0] ) /
          ( $buttonA->[$i][1] * $buttonB->[$i][0] -
              $buttonA->[$i][0] * $buttonB->[$i][1] );
        my $contri_a =
          ( $prizes->[$i][0] - $buttonB->[$i][0] * $contri_b ) /
          $buttonA->[$i][0];

        if ( $contri_b == int($contri_b) and $contri_a == int($contri_a) ) {
            $part2 += $cost_a * $contri_a + $cost_b * $contri_b;
        }
    }
    say "part2: $part2";
}
part2( \@buttonA, \@buttonB, \@prizes, $cost_a, $cost_b, $num_prizes );
