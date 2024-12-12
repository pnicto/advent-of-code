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
@input = map { [ split( //, $_ ) ] } @input;

my @directions = ( [ -1, 0 ], [ 0, 1 ], [ 1, 0 ], [ 0, -1 ] );

sub calculate_area_and_perimeter {
    my ( $input, $row, $col, $visited, $area, $perimeter, $m, $n, $tile ) = @_;

    if (   $row < 0
        or $row >= $m
        or $col < 0
        or $col >= $n
        or $input->[$row][$col] ne $tile )
    {
        return;
    }

    if ( exists $visited->{"$row,$col"} ) {
        return;
    }

    $visited->{"$row,$col"} = 1;
    ${$area}++;

    if ( $row - 1 < 0 or $input->[ $row - 1 ][$col] ne $tile ) {
        ${$perimeter}++;
    }
    if ( $row + 1 >= $m or $input->[ $row + 1 ][$col] ne $tile ) {
        ${$perimeter}++;
    }
    if ( $col - 1 < 0 or $input->[$row][ $col - 1 ] ne $tile ) {
        ${$perimeter}++;
    }
    if ( $col + 1 >= $n or $input->[$row][ $col + 1 ] ne $tile ) {
        ${$perimeter}++;
    }

    for my $direction (@directions) {
        my $new_row = $row + $direction->[0];
        my $new_col = $col + $direction->[1];
        calculate_area_and_perimeter(
            $input,     $new_row, $new_col, $visited, $area,
            $perimeter, $m,       $n,       $tile
        );
    }
}

sub part1 {
    my $input      = shift;
    my $m          = scalar @{$input};
    my $n          = scalar @{ $input->[0] };
    my $total_cost = 0;
    my %visited;

    for my $i ( 0 .. $m - 1 ) {
        for my $j ( 0 .. $n - 1 ) {
            if ( not exists $visited{"$i,$j"} ) {
                my $area      = 0;
                my $perimeter = 0;

                calculate_area_and_perimeter( $input, $i, $j, \%visited,
                    \$area, \$perimeter, $m, $n, $input->[$i][$j] );

                $total_cost += $area * $perimeter;
            }
        }
    }

    say "part1: $total_cost";
}

part1( \@input );

sub part2 {
    my $input = shift;
    my %visited;
    my $m = scalar @{$input};
    my $n = scalar @{ $input->[0] };

    my $total_cost = 0;

    for my $i ( 0 .. $m - 1 ) {
        for my $j ( 0 .. $n - 1 ) {
            if ( not exists $visited{"$i,$j"} ) {
                my $perimeter = 0;
                my $area      = 0;
                my %temp;
                my %top_contri;
                my %bottom_contri;
                my %right_contri;
                my %left_contri;

                calculate_area_and_perimeter2(
                    $input,       $i,              $j,
                    \%temp,       \$area,          \$perimeter,
                    $m,           $n,              $input->[$i][$j],
                    \%top_contri, \%bottom_contri, \%right_contri,
                    \%left_contri
                );

                my $sides = 0;
                $sides = find_sides(
                    \%temp,         \%top_contri,     \%bottom_contri,
                    \%right_contri, \%left_contri,    $m,
                    $n,             $input->[$i][$j], $input
                );
                $total_cost += $area * $sides;

                for my $key ( keys %temp ) {
                    $visited{$key} = 1;
                }

            }
        }
    }

    say "part2: $total_cost";
}

part2( \@input );

sub find_sides {
    my (
        $vis,          $top_contri,  $bottom_contri,
        $right_contri, $left_contri, $m,
        $n,            $tile,        $input
    ) = @_;
    my $sides = 0;

    for my $key ( keys %{$vis} ) {
        my ( $row, $col ) = split( /,/, $key );

        if ( $row - 1 < 0 or $input->[ $row - 1 ][$col] ne $tile ) {
            my $ncol = $col - 1;
            while ( $ncol >= 0
                and $input->[$row][$ncol] eq $tile
                and exists $top_contri->{"$row,$ncol"} )
            {
                if ( $top_contri->{"$row,$ncol"} > 0 ) {
                    $top_contri->{"$row,$ncol"}--;
                }
                $ncol--;
            }
        }
        if ( $row + 1 >= $m or $input->[ $row + 1 ][$col] ne $tile ) {
            my $ncol = $col - 1;
            while ( $ncol >= 0
                and $input->[$row][$ncol] eq $tile
                and exists $bottom_contri->{"$row,$ncol"} )
            {
                if ( $bottom_contri->{"$row,$ncol"} > 0 ) {
                    $bottom_contri->{"$row,$ncol"}--;
                }
                $ncol--;
            }
        }
        if ( $col - 1 < 0 or $input->[$row][ $col - 1 ] ne $tile ) {
            my $nrow = $row - 1;
            while ( $nrow >= 0
                and $input->[$nrow][$col] eq $tile
                and exists $left_contri->{"$nrow,$col"} )
            {
                if ( $left_contri->{"$nrow,$col"} > 0 ) {
                    $left_contri->{"$nrow,$col"}--;
                }
                $nrow--;
            }
        }

        if ( $col + 1 >= $n or $input->[$row][ $col + 1 ] ne $tile ) {
            my $nrow = $row - 1;
            while ( $nrow >= 0
                and $input->[$nrow][$col] eq $tile
                and exists $right_contri->{"$nrow,$col"} )
            {
                if ( $right_contri->{"$nrow,$col"} > 0 ) {
                    $right_contri->{"$nrow,$col"}--;
                }
                $nrow--;
            }
        }
    }

    for my $key ( keys %{$top_contri} ) {
        $sides++ if $top_contri->{$key} > 0;
    }
    for my $key ( keys %{$bottom_contri} ) {
        $sides++ if $bottom_contri->{$key} > 0;
    }
    for my $key ( keys %{$right_contri} ) {
        $sides++ if $right_contri->{$key} > 0;
    }
    for my $key ( keys %{$left_contri} ) {
        $sides++ if $left_contri->{$key} > 0;
    }

    return $sides;
}

sub calculate_area_and_perimeter2 {
    my (
        $input, $row,        $col,           $visited,
        $area,  $perimeter,  $m,             $n,
        $tile,  $top_contri, $bottom_contri, $right_contri,
        $left_contri
    ) = @_;

    if (   $row < 0
        or $row >= $m
        or $col < 0
        or $col >= $n
        or $input->[$row][$col] ne $tile )
    {
        return;
    }

    if ( exists $visited->{"$row,$col"} ) {
        return;
    }

    $visited->{"$row,$col"} = 1;
    ${$area}++;

    if ( $row - 1 < 0 or $input->[ $row - 1 ][$col] ne $tile ) {
        ${$perimeter}++;
        $top_contri->{"$row,$col"}++;
    }
    if ( $row + 1 >= $m or $input->[ $row + 1 ][$col] ne $tile ) {
        ${$perimeter}++;
        $bottom_contri->{"$row,$col"}++;
    }
    if ( $col - 1 < 0 or $input->[$row][ $col - 1 ] ne $tile ) {
        ${$perimeter}++;
        $left_contri->{"$row,$col"}++;
    }
    if ( $col + 1 >= $n or $input->[$row][ $col + 1 ] ne $tile ) {
        ${$perimeter}++;
        $right_contri->{"$row,$col"}++;
    }

    for my $direction (@directions) {
        my $new_row = $row + $direction->[0];
        my $new_col = $col + $direction->[1];
        calculate_area_and_perimeter2(
            $input, $new_row,    $new_col,       $visited,
            $area,  $perimeter,  $m,             $n,
            $tile,  $top_contri, $bottom_contri, $right_contri,
            $left_contri
        );
    }
}

