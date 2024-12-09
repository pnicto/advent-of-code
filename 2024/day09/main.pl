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
chomp $input;

sub generate_filesystem {
    my $input      = shift;
    my @filesystem = ();
    my $id         = 0;
    my $n          = length($input);
    for my $i ( 0 .. $n - 1 ) {
        if ( $i % 2 == 0 ) {
            for my $j ( 0 .. substr( $input, $i, 1 ) - 1 ) {
                push @filesystem, $id;
            }
            $id++;
        }
        else {
            for my $j ( 0 .. substr( $input, $i, 1 ) - 1 ) {
                push @filesystem, ".";
            }
        }
    }
    return @filesystem;
}

sub rearrange_filesystem {
    my (@filesystem) = @_;

    my $left  = 0;
    my $right = @filesystem - 1;
    my $n     = $right - 1;

    while ( $filesystem[$left] ne "." )  { $left++; }
    while ( $filesystem[$right] eq "." ) { $right--; }
    while ( $left < $right ) {

        # swap left and right
        ( $filesystem[$left], $filesystem[$right] ) =
          ( $filesystem[$right], $filesystem[$left] );
        $left++;
        $right--;

        while ( $filesystem[$left] ne "." && $left < $n ) {
            $left++;
        }
        while ( $filesystem[$right] eq "." && $right >= 0 ) {
            $right--;
        }
    }
    return @filesystem;
}

sub calculate_checksum {
    my (@filesystem) = @_;
    my $n            = @filesystem - 1;
    my $checksum     = 0;
    for my $index ( 0 .. $n ) {
        if ( $filesystem[$index] eq "." ) {
            next;
        }
        $checksum += $index * $filesystem[$index];
    }
    return $checksum;
}

sub part1 {
    my @filesystem = generate_filesystem($input);
    say "filesystem generated";
    my @rearranged = rearrange_filesystem(@filesystem);
    say "filesystem rearranged";
    say "part 1: ", calculate_checksum(@rearranged);
}

part1();

