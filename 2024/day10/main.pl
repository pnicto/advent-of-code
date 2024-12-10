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

my $input = path($file)->slurp;
my @input = split( /\n/, $input );

for my $i ( 0 .. $#input ) {
    $input[$i] = [ split( //, $input[$i] ) ];
}

sub dfs {
    my $row         = shift;
    my $col         = shift;
    my $is_part2    = shift;
    my $count_ref   = shift;
    my $visited_ref = shift;
    my $m           = @input;
    my $n           = @{ $input[0] };

    if ( $row < 0 or $row >= $m or $col < 0 or $col >= $n ) {
        return;
    }

    if ( not $is_part2 ) {
        if ( $visited_ref->{$row}{$col} ) {
            return;
        }

        $visited_ref->{$row}{$col} = 1;
    }

    if ( $input[$row][$col] eq "9" ) {
        ${$count_ref}++;
        return;
    }

    my @directions = ( [ -1, 0 ], [ 1, 0 ], [ 0, -1 ], [ 0, 1 ] );
    for my $dir (@directions) {
        my $new_row = $row + $dir->[0];
        my $new_col = $col + $dir->[1];
        if ( $new_row < 0 or $new_row >= $m or $new_col < 0 or $new_col >= $n )
        {
            next;
        }

        if ( $input[$new_row][$new_col] == $input[$row][$col] + 1 ) {
            dfs( $new_row, $new_col, $is_part2, $count_ref, $visited_ref );
        }
    }
}

sub trailhead_count {
    my ( $row, $col, $is_part2 ) = @_;
    my $count = 0;

    my %visited;
    dfs( $row, $col, $is_part2, \$count, \%visited );
    return $count;
}

sub part1 {
    my $count = 0;
    my $m     = @input;
    my $n     = @{ $input[0] };

    for my $i ( 0 .. $m - 1 ) {
        for my $j ( 0 .. $n - 1 ) {
            if ( $input[$i][$j] eq "0" ) {
                $count += trailhead_count( $i, $j );
            }
        }
    }

    say "Part 1: $count";
}

part1();

sub part2 {
    my $count = 0;
    my $m     = @input;
    my $n     = @{ $input[0] };

    for my $i ( 0 .. $m - 1 ) {
        for my $j ( 0 .. $n - 1 ) {
            if ( $input[$i][$j] eq "0" ) {
                $count += trailhead_count( $i, $j, 1 );
            }
        }
    }

    say "Part 2: $count";
}

part2();
