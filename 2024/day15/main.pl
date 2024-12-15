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

my ( $map_str, $movement_str ) = split( /\n\n/, $input );

# make the map str into arrays
my @map = split( /\n/, $map_str );
for my $index ( 0 .. $#map ) {
    $map[$index] = [ split( //, $map[$index] ) ];
}

# remove new lines
$movement_str =~ s/\n//g;

my %directions = (
    "<" => [  0, -1 ],
    ">" => [  0,  1 ],
    "^" => [ -1,  0 ],
    "v" => [  1,  0 ],
);

sub part1 {
    my ( $map, $movement ) = @_;
    my $m = @$map;
    my $n = @{ $map->[0] };
    my $robot;

    # find robot starting position
    for my $i ( 0 .. $m - 1 ) {
        for my $j ( 0 .. $n - 1 ) {
            if ( $map->[$i][$j] eq "@" ) {
                $robot = [ $i, $j ];
                $map->[$i][$j] = ".";
            }
        }
    }

    for my $move ( split( //, $movement ) ) {
        my ( $dx, $dy ) = @{ $directions{$move} };
        my ( $nx, $ny ) = ( $robot->[0] + $dx, $robot->[1] + $dy );
        if ( $map->[$nx][$ny] eq "O" ) {

            # check if there is space to move the boxes
            my ( $sx, $sy ) = ( $nx, $ny );
            my $is_found = 0;
            while ( $sx > 0 && $sx < $m - 1 && $sy > 0 && $sy < $n - 1 ) {
                if ( $map->[$sx][$sy] eq "#" ) {
                    last;
                }
                if ( $map->[$sx][$sy] eq "." ) {
                    $is_found = 1;
                    last;
                }
                $sx += $dx;
                $sy += $dy;
            }

            if ($is_found) {
                while ( $sx != $nx || $sy != $ny ) {
                    $map->[$sx][$sy] = "O";
                    $sx -= $dx;
                    $sy -= $dy;
                }

                $map->[$sx][$sy] = ".";
                $robot = [ $nx, $ny ];
            }
        }
        elsif ( $map->[$nx][$ny] eq "." ) {
            $robot = [ $nx, $ny ];
        }
        else {
            next;
        }
    }

    my $part1 = 0;
    for my $i ( 0 .. $m - 1 ) {
        for my $j ( 0 .. $n - 1 ) {
            if ( $map->[$i][$j] eq "O" ) {
                $part1 += 100 * $i + $j;
            }
        }
    }
    say "part1: $part1";
}

my @updated_map;
for my $row (@map) {
    my @new_row;
    for my $val (@$row) {
        if ( $val eq "@" ) {
            push @new_row, "@";
            push @new_row, ".";
        }
        elsif ( $val eq "#" ) {
            push @new_row, "#";
            push @new_row, "#";
        }
        elsif ( $val eq "O" ) {
            push @new_row, "[";
            push @new_row, "]";
        }
        elsif ( $val eq "." ) {
            push @new_row, ".";
            push @new_row, ".";
        }
    }
    push @updated_map, \@new_row;
}

sub part2 {
    my ( $map, $movement ) = @_;
    my $m = @$map;
    my $n = @{ $map->[0] };
    my $robot;

    # find robot starting position
    for my $i ( 0 .. $m - 1 ) {
        for my $j ( 0 .. $n - 1 ) {
            if ( $map->[$i][$j] eq "@" ) {
                $robot = [ $i, $j ];
                $map->[$i][$j] = ".";
            }
        }
    }

    for my $move ( split( //, $movement ) ) {
        my ( $dx, $dy ) = @{ $directions{$move} };
        my ( $nx, $ny ) = ( $robot->[0] + $dx, $robot->[1] + $dy );

        ## debug
        #for my $row ( 0 .. ( scalar @$map ) - 1 ) {
        #    for my $col ( 0 .. ( scalar @{ $map->[0] } ) - 1 ) {
        #        if ( $row == $robot->[0] && $col == $robot->[1] ) {
        #            print "@";
        #        }
        #        else {
        #            print $map->[$row][$col];
        #        }
        #    }
        #    print "\n";
        #}
        #
        ## debug end

        dump $nx, $ny, $move;

        if ( $map->[$nx][$ny] eq "[" ) {
            my ( $sx1, $sy1 ) = ( $nx, $ny );
            my ( $sx2, $sy2 ) = ( $nx, $ny + 1 );
            if ( $move eq ">" || $move eq "<" ) {
                my $is_found = 0;
                while ( $sx1 > 0 && $sx1 < $m - 1 && $sy1 > 0 && $sy1 < $n - 1 )
                {
                    if ( $map->[$sx1][$sy1] eq "#" ) { last; }
                    if ( $map->[$sx1][$sy1] eq "." ) {
                        $is_found = 1;
                        last;
                    }

                    $sx1 += $dx;
                    $sy1 += $dy;
                }

                my $idx = 0;
                if ($is_found) {
                    while ( $sx1 != $nx || $sy1 != $ny ) {
                        if ( $idx % 2 ) {
                            $map->[$sx1][$sy1] = "[";
                        }
                        else {
                            $map->[$sx1][$sy1] = "]";
                        }
                        $idx += 1;
                        $sx1 -= $dx;
                        $sy1 -= $dy;
                    }

                    $map->[$sx1][$sy1] = ".";
                    $robot = [ $nx, $ny ];
                }
            }
            else {
# for moving up and down we need to find all affected boxes and then check if we have the way to move or not and then make the moving
                my @affected;
                my %seen;
                my @queue;
                push @queue,    [ $nx, $ny ];
                push @affected, [ $nx, $ny ];

                $seen{"$nx,$ny"} = 1;

                push @queue,    [ $nx, $ny + 1 ];
                push @affected, [ $nx, $ny + 1 ];
                $seen{"$nx,@{[$ny+1]}"} = 1;

                my $has_space = 1;

                while (@queue) {
                    my ( $rx, $ry ) = @{ shift @queue };
                    my $sx = $rx + $dx;
                    my $sy = $ry + $dy;

                    #dump $sx, $sy, $map->[$sx][$sy];

                    if ( $map->[$sx][$sy] eq "]" ) {
                        if ( not exists $seen{"$sx,$sy"} ) {
                            push @queue,    [ $sx, $sy ];
                            push @affected, [ $sx, $sy ];
                            $seen{"$sx,$sy"} = 1;
                        }

                        if ( not exists $seen{"$sx,@{[$sy-1]}"} ) {
                            push @queue,    [ $sx, $sy - 1 ];
                            push @affected, [ $sx, $sy - 1 ];
                            $seen{"$sx,@{[$sy-1]}"} = 1;
                        }
                    }
                    elsif ( $map->[$sx][$sy] eq "[" ) {
                        if ( not exists $seen{"$sx,$sy"} ) {
                            push @queue,    [ $sx, $sy ];
                            push @affected, [ $sx, $sy ];
                            $seen{"$sx,$sy"} = 1;
                        }

                        if ( not exists $seen{"$sx,@{[$sy+1]}"} ) {
                            push @queue,    [ $sx, $sy + 1 ];
                            push @affected, [ $sx, $sy + 1 ];
                            $seen{"$sx,@{[$sy+1]}"} = 1;
                        }
                    }
                    elsif ( $map->[$sx][$sy] eq "#" ) {
                        $has_space = 0;
                        last;
                    }
                }

                if ( $move eq "^" ) {
                    @affected =
                      sort { $a->[0] <=> $b->[0] || $a->[1] <=> $b->[1] }
                      @affected;
                }
                else {
                    @affected =
                      sort { $b->[0] <=> $a->[0] || $b->[1] <=> $a->[1] }
                      @affected;
                }

                # if we found some space we can move all of the affected onces
                if ($has_space) {
                    for my $af (@affected) {
                        my ( $nrow, $ncol ) =
                          ( $af->[0] + $dx, $af->[1] + $dy );

                        my $temp = $map->[ $af->[0] ][ $af->[1] ];
                        $map->[ $af->[0] ][ $af->[1] ] = ".";
                        $map->[$nrow][$ncol] = $temp;
                    }
                    $robot = [ $nx, $ny ];
                }
            }
        }
        elsif ( $map->[$nx][$ny] eq "]" ) {
            my ( $sx1, $sy1 ) = ( $nx, $ny );
            my ( $sx2, $sy2 ) = ( $nx, $ny - 1 );
            if ( $move eq ">" || $move eq "<" ) {
                my $is_found = 0;
                while ( $sx2 > 0 && $sx2 < $m - 1 && $sy2 > 0 && $sy2 < $n - 1 )
                {
                    if ( $map->[$sx2][$sy2] eq "#" ) { last; }
                    if ( $map->[$sx2][$sy2] eq "." ) {
                        $is_found = 1;
                        last;
                    }
                    $sx2 += $dx;
                    $sy2 += $dy;
                }

                my $idx = 0;
                if ($is_found) {
                    while ( $sx2 != $nx || $sy2 != $ny ) {
                        if ( $idx % 2 ) {
                            $map->[$sx2][$sy2] = "]";
                        }
                        else {
                            $map->[$sx2][$sy2] = "[";
                        }
                        $idx += 1;
                        $sx2 -= $dx;
                        $sy2 -= $dy;
                    }

                    $map->[$sx2][$sy2] = ".";
                    $robot = [ $nx, $ny ];
                }
            }
            else {
                my @affected;
                my %seen;
                my @queue;
                push @queue,    [ $nx, $ny ];
                push @affected, [ $nx, $ny ];

                $seen{"$nx,$ny"} = 1;

                push @queue,    [ $nx, $ny - 1 ];
                push @affected, [ $nx, $ny - 1 ];
                $seen{"$nx,@{[$ny-1]}"} = 1;

                my $has_space = 1;

                while (@queue) {
                    my ( $rx, $ry ) = @{ shift @queue };
                    my $sx = $rx + $dx;
                    my $sy = $ry + $dy;

                    #dump $sx, $sy, $map->[$sx][$sy];

                    if ( $map->[$sx][$sy] eq "]" ) {
                        if ( not exists $seen{"$sx,$sy"} ) {
                            push @queue,    [ $sx, $sy ];
                            push @affected, [ $sx, $sy ];
                            $seen{"$sx,$sy"} = 1;
                        }

                        if ( not exists $seen{"$sx,@{[$sy-1]}"} ) {
                            push @queue,    [ $sx, $sy - 1 ];
                            push @affected, [ $sx, $sy - 1 ];
                            $seen{"$sx,@{[$sy-1]}"} = 1;
                        }
                    }
                    elsif ( $map->[$sx][$sy] eq "[" ) {
                        if ( not exists $seen{"$sx,$sy"} ) {
                            push @queue,    [ $sx, $sy ];
                            push @affected, [ $sx, $sy ];
                            $seen{"$sx,$sy"} = 1;
                        }

                        if ( not exists $seen{"$sx,@{[$sy+1]}"} ) {
                            push @queue,    [ $sx, $sy + 1 ];
                            push @affected, [ $sx, $sy + 1 ];
                            $seen{"$sx,@{[$sy+1]}"} = 1;
                        }
                    }
                    elsif ( $map->[$sx][$sy] eq "#" ) {
                        $has_space = 0;
                        last;
                    }
                }

                if ( $move eq "^" ) {
                    @affected =
                      sort { $a->[0] <=> $b->[0] || $a->[1] <=> $b->[1] }
                      @affected;
                }
                else {
                    @affected =
                      sort { $b->[0] <=> $a->[0] || $b->[1] <=> $a->[1] }
                      @affected;
                }

                # if we found some space we can move all of the affected onces
                if ($has_space) {
                    for my $af (@affected) {
                        my ( $nrow, $ncol ) =
                          ( $af->[0] + $dx, $af->[1] + $dy );

                        my $temp = $map->[ $af->[0] ][ $af->[1] ];
                        $map->[ $af->[0] ][ $af->[1] ] = ".";
                        $map->[$nrow][$ncol] = $temp;
                    }
                    $robot = [ $nx, $ny ];
                }
            }
        }
        elsif ( $map->[$nx][$ny] eq "." ) {
            $robot = [ $nx, $ny ];
        }
        else {
            next;
        }
    }

    ## debug
    #for my $row ( 0 .. ( scalar @$map ) - 1 ) {
    #    for my $col ( 0 .. ( scalar @{ $map->[0] } ) - 1 ) {
    #        if ( $row == $robot->[0] && $col == $robot->[1] ) {
    #            print "@";
    #        }
    #        else {
    #            print $map->[$row][$col];
    #        }
    #    }
    #    print "\n";
    #}

    # debug end
    say "done";
    my $part2 = 0;
    for my $i ( 0 .. $m - 1 ) {
        for my $j ( 0 .. $n - 1 ) {
            if ( $map->[$i][$j] eq "[" ) {
                $part2 += 100 * $i + $j;
            }
        }
    }
    say "part2: $part2";

}

part1( \@map, $movement_str );
part2( \@updated_map, $movement_str );
