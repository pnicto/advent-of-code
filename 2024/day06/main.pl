use 5.010;
use strict;
use warnings;

use Data::Dump qw(dump);
use Path::Tiny;
use autodie;

my $file  = path(".")->child("input.txt");
my $input = $file->slurp_utf8();
my @map   = split( /\n/, $input );
@map = map { [ split( //, $_ ) ] } @map;
dump @map;

my $m = $#map;
my $n = $#{ $map[0] };

# find the starting point
my $x;
my $y;
for my $i ( 0 .. $m ) {
    for my $j ( 0 .. $n ) {
        if ( $map[$i][$j] eq '^' ) {
            $x = $i;
            $y = $j;
            last;
        }
    }
}
my $start = [ $x, $y ];
dump $x, $y;

my $part1 = 0;

# doing the simulation
my @directions        = ( [ -1, 0 ], [ 0, 1 ], [ 1, 0 ], [ 0, -1 ], );
my $current_direction = 0;

while ( $x >= 0 && $x <= $m && $y >= 0 && $y <= $n ) {
    my $dx = $directions[$current_direction][0];
    my $dy = $directions[$current_direction][1];
    $map[$x][$y] = '%';

    my $next_x = $x + $dx;
    my $next_y = $y + $dy;

    if ( $next_x < 0 || $next_x > $m || $next_y < 0 || $next_y > $n ) {
        last;
    }

    if ( $map[$next_x][$next_y] eq '#' ) {
        $current_direction = ( $current_direction + 1 ) % 4;
    }
    else {
        $x = $next_x;
        $y = $next_y;
    }
}

#dump @map;
# count the number of painted cells
map {
    $part1 += grep { $_ eq '%' }
      @$_
} @map;
say "part1: $part1";

sub loop_check {
    my $x                 = shift;
    my $y                 = shift;
    my $current_direction = shift;
    my @map               = @_;

    my %visited;

    while ( $x >= 0 && $x <= $m && $y >= 0 && $y <= $n ) {
        if ( $visited{"$x,$y,$current_direction"} ) {
            return 1;
        }
        $visited{"$x,$y,$current_direction"} = 1;
        my $dx = $directions[$current_direction][0];
        my $dy = $directions[$current_direction][1];

        my $next_x = $x + $dx;
        my $next_y = $y + $dy;

        if ( $next_x < 0 || $next_x > $m || $next_y < 0 || $next_y > $n ) {
            last;
        }

        if ( $map[$next_x][$next_y] eq '#' ) {
            $current_direction = ( $current_direction + 1 ) % 4;
        }
        else {
            $x = $next_x;
            $y = $next_y;
        }
    }

    return 0;
}

my $part2 = 0;
$x                 = $start->[0];
$y                 = $start->[1];
$current_direction = 0;

for my $i ( 0 .. $m ) {
    for my $j ( 0 .. $n ) {
        if ( $map[$i][$j] ne '#' ) {
            my $temp = $map[$i][$j];
            $map[$i][$j] = '#';
            dump $i, $j, $m, $n;
            if ( loop_check( $x, $y, $current_direction, @map ) ) {
                $part2++;
            }
            $map[$i][$j] = $temp;
        }
    }
}

say "part2: $part2";
