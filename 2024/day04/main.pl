use 5.010;
use strict;
use warnings;

use Data::Dump qw(dump);
use Path::Tiny;
use List::MoreUtils qw(zip);
use List::MoreUtils qw(frequency);
use autodie;

my $file  = path(".")->child("input.txt");
my $input = $file->slurp_utf8();
my @input = split( /\n/, $input );

while ( my ( $index, $element ) = each @input ) {
    $input[$index] = [ split( "", $element ) ];
}

my $m = @input;
my $n = @{ $input[0] };

my $part1      = 0;
my @directions = (
    [ -1,  0 ], [  1, 0 ], [ 0, -1 ], [ 0, 1 ],
    [ -1, -1 ], [ -1, 1 ], [ 1, -1 ], [ 1, 1 ],
);

for ( my $row = 0 ; $row < $m ; $row++ ) {
    for ( my $col = 0 ; $col < $n ; $col++ ) {
        next if $input[$row][$col] ne "X";

        say "new iteration";
        say "$row, $col";
        for my $dir (@directions) {
            my ( $r_offset, $c_offset ) = @$dir;
            my $found = 1;

            for my $i ( 1 .. 3 ) {
                my $new_row = $row + $r_offset * $i;
                my $new_col = $col + $c_offset * $i;

                if (   $new_row < 0
                    || $new_row >= $m
                    || $new_col < 0
                    || $new_col >= $n )
                {
                    $found = 0;
                    last;
                }
                say "$new_row, $new_col $input[$new_row][$new_col]";

                if ( $input[$new_row][$new_col] ne substr( "XMAS", $i, 1 ) ) {
                    $found = 0;
                    say "discontinued $new_row, $new_col";
                    last;
                }
            }

            if ($found) {
                $part1++;
            }
        }
    }
}

say "part1 : $part1";

my $part2 = 0;
for ( my $row = 0 ; $row < $m ; $row++ ) {
    for ( my $col = 0 ; $col < $n ; $col++ ) {
        next if $input[$row][$col] ne "A";

        say "iteration $row, $col";
        my $is_xmas = 1;
        if ( $row - 1 >= 0 && $row + 1 < $m && $col - 1 >= 0 && $col + 1 < $n )
        {
            if (
                not(
                    (
                            $input[ $row - 1 ][ $col - 1 ] eq "M"
                        and $input[ $row + 1 ][ $col + 1 ] eq "S"
                    )
                    or (    $input[ $row - 1 ][ $col - 1 ] eq "S"
                        and $input[ $row + 1 ][ $col + 1 ] eq "M" )
                )
              )
            {
                $is_xmas = 0;
            }
            if (
                not(
                    (
                            $input[ $row + 1 ][ $col - 1 ] eq "M"
                        and $input[ $row - 1 ][ $col + 1 ] eq "S"
                    )
                    or (    $input[ $row + 1 ][ $col - 1 ] eq "S"
                        and $input[ $row - 1 ][ $col + 1 ] eq "M" )
                )
              )
            {
                $is_xmas = 0;
            }
        }
        else {
            $is_xmas = 0;
        }

        if ($is_xmas) {
            say "found for $row, $col";
            $part2++;
        }
        say "";
    }
}
say "part2 : $part2";
