use 5.010;
use strict;
use warnings;

use Data::Dump   qw(dump);
use Path::Tiny   qw(path);
use Scalar::Util qw(looks_like_number);
use autodie;

my $file = $ARGV[0];
if ( not defined $file ) {
    say "Using default as sample.txt";
    $file = "sample.txt";
}

my $input = path($file)->slurp;

package Robot {
    use Moose;

    has "position" => ( is => "rw", isa => "ArrayRef[Int]" );
    has "velocity" => ( is => "rw", isa => "ArrayRef[Int]" );
}

my @input = split( /\n/, $input );
my @robots;
for my $line (@input) {
    my ( $position_string, $velocity_string ) = split( / /, $line );

    my @parts;
    my ( $px, $py, $vx, $vy );

    @parts = split( /,/, $position_string );
    $px    = substr( $parts[0], 2 );
    $py    = $parts[1];

    @parts = split( /,/, $velocity_string );
    $vx    = substr( $parts[0], 2 );
    $vy    = $parts[1];

    my $robot = Robot->new(
        position => [ $py, $px ],
        velocity => [ $vy, $vx ]
    );
    push @robots, $robot;
}

sub draw_and_get_grid {
    my ( $robots, $m, $n ) = @_;

    my @grid;

    for my $i ( 1 .. $m ) {
        my @row;
        for my $j ( 1 .. $n ) {
            push @row, ".";
        }
        push @grid, \@row;
    }

    for my $robot (@$robots) {
        my $position = $robot->position;
        if ( $grid[ $position->[0] ][ $position->[1] ] eq "." ) {
            $grid[ $position->[0] ][ $position->[1] ] = 1;
        }
        else {
            $grid[ $position->[0] ][ $position->[1] ]++;
        }
    }

    for my $row (@grid) {
        dump $row;
    }

    return \@grid;
}

sub simulate_robot {
    my ( $robot, $m, $n ) = @_;
    my $position = $robot->position;
    my $velocity = $robot->velocity;

    my $new_position =
      [ $position->[0] + $velocity->[0], $position->[1] + $velocity->[1] ];

    if ( $new_position->[0] < 0 ) {
        $new_position->[0] += $m;
    }
    if ( $new_position->[1] < 0 ) {
        $new_position->[1] += $n;
    }
    if ( $new_position->[0] >= $m ) {
        $new_position->[0] -= $m;
    }
    if ( $new_position->[1] >= $n ) {
        $new_position->[1] -= $n;
    }
    $robot->position($new_position);
}

sub calculate_safety_factor {
    my ( $grid, $m, $n ) = @_;

    # quad 1
    my $quad1 = 0;
    for my $i ( 0 .. ( $m / 2 ) - 1 ) {
        for my $j ( 0 .. ( $n / 2 ) - 1 ) {
            if ( looks_like_number( $grid->[$i][$j] ) ) {
                $quad1 += $grid->[$i][$j];
            }
        }
    }

    # quad 2
    my $quad2 = 0;
    for my $i ( 0 .. ( $m / 2 ) - 1 ) {
        for my $j ( ( $n / 2 ) + 1 .. $n - 1 ) {
            if ( looks_like_number( $grid->[$i][$j] ) ) {
                $quad2 += $grid->[$i][$j];
            }
        }
    }

    # quad 3
    my $quad3 = 0;
    for my $i ( ( $m / 2 ) + 1 .. $m - 1 ) {
        for my $j ( 0 .. ( $n / 2 ) - 1 ) {
            if ( looks_like_number( $grid->[$i][$j] ) ) {
                $quad3 += $grid->[$i][$j];
            }
        }
    }

    # quad 4
    my $quad4 = 0;
    for my $i ( ( $m / 2 ) + 1 .. $m - 1 ) {
        for my $j ( ( $n / 2 ) + 1 .. $n - 1 ) {
            if ( looks_like_number( $grid->[$i][$j] ) ) {
                $quad4 += $grid->[$i][$j];
            }
        }
    }

    return $quad1 * $quad2 * $quad3 * $quad4;
}

sub part1 {
    my ( $simulation_limit_in_seconds, $robots, $m, $n ) = @_;

    # initial grid
    #draw_and_get_grid( $robots, $m, $n );

    for my $second ( 1 .. $simulation_limit_in_seconds ) {
        for my $robot (@$robots) {
            simulate_robot( $robot, $m, $n );
        }
    }

    # final grid
    say "final grid";
    my $grid = draw_and_get_grid( $robots, $m, $n );

    say "part1: ", calculate_safety_factor( $grid, $m, $n );

}

part1( 100, \@robots, 103, 101 );
