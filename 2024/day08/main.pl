use 5.010;
use strict;
use warnings;

use Data::Dump "dump";
use Path::Tiny;
use autodie;

my $file  = $ARGV[0];
my $input = path($file)->slurp;

my @input = split( /\n/, $input );
my $m     = @input;
my $n     = length( $input[0] );

while ( my ( $index, $line ) = each @input ) {
    $input[$index] = [ split( //, $line ) ];
}

dump @input;

my %antinodes;
my %frequency_map;

sub find_antinodes {
    my ( $row, $col ) = @_;
}

for my $row ( 0 .. $m - 1 ) {
    for my $col ( 0 .. $n - 1 ) {
        if ( $input[$row][$col] ne '.' ) {
            if ( not exists $frequency_map{ $input[$row][$col] } ) {
                $frequency_map{ $input[$row][$col] } = [];
            }
            push @{ $frequency_map{ $input[$row][$col] } }, [ $row, $col ];
        }
    }
}

my @input_copy = @input;
while ( my ( $key, $value ) = each %frequency_map ) {
    my @pairs = @$value;
    for my $i ( 0 .. $#pairs ) {
        for my $j ( $i + 1 .. $#pairs ) {
            my $x_dist = abs( $pairs[$i][0] - $pairs[$j][0] );
            my $y_dist = abs( $pairs[$i][1] - $pairs[$j][1] );

            my $antinode1;
            my $antinode2;
            if ( $pairs[$i][1] < $pairs[$j][1] ) {
                $antinode1 =
                  [ $pairs[$i][0] - $x_dist, $pairs[$i][1] - $y_dist ];
                $antinode2 =
                  [ $pairs[$j][0] + $x_dist, $pairs[$j][1] + $y_dist ];
            }
            else {
                $antinode1 =
                  [ $pairs[$i][0] - $x_dist, $pairs[$i][1] + $y_dist ];
                $antinode2 =
                  [ $pairs[$j][0] + $x_dist, $pairs[$j][1] - $y_dist ];
            }

            if (    $antinode1->[0] >= 0
                and $antinode1->[0] < $m
                and $antinode1->[1] >= 0
                and $antinode1->[1] < $n )
            {
                $antinodes{"$antinode1->[0],$antinode1->[1]"} = 1;
                $input_copy[ $antinode1->[0] ][ $antinode1->[1] ] = '#';
            }
            if (    $antinode2->[0] >= 0
                and $antinode2->[0] < $m
                and $antinode2->[1] >= 0
                and $antinode2->[1] < $n )
            {
                $antinodes{"$antinode2->[0],$antinode2->[1]"} = 1;
                $input_copy[ $antinode2->[0] ][ $antinode2->[1] ] = '#';
            }

        }
    }
}

dump \%antinodes;

my $part1 = scalar keys %antinodes;
say "Part 1: $part1";

