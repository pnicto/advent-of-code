use 5.010;
use strict;
use warnings;

use Data::Dump      qw(dump);
use Path::Tiny      qw(path);
use List::MoreUtils qw(zip);
use autodie;

my $file = $ARGV[0];
if ( not defined $file ) {
    say "Using default as sample.txt";
    $file = "sample.txt";
}

my $input = path($file)->slurp;
chomp $input;
my @input = split( / /, $input );

sub arrange_helper {
    my ($seen_ref) = @_;

    my %next;
    while ( my ( $num, $freq ) = each %{$seen_ref} ) {
        if ( $num == 0 ) {
            $next{1} += $freq;
        }
        elsif ( length($num) % 2 == 0 ) {
            my $half = length($num) / 2;
            my $num1 = int( substr( $num, 0, $half ) );
            my $num2 = int( substr( $num, $half ) );

            $next{$num1} += $freq;
            $next{$num2} += $freq;
        }
        else {
            $next{ $num * 2024 } += $freq;
        }
    }

    return \%next;
}

sub arrange_stones_after_blinks {
    my $num_blinks = shift;
    my (@input) = @_;
    my %seen;
    for my $ele (@input) {
        $seen{$ele}++;
    }
    my $seen_ref = \%seen;
    for my $blink ( 1 .. $num_blinks ) {
        $seen_ref = arrange_helper($seen_ref);
    }

    my $total_freq = 0;
    for my ($freq) ( values %{$seen_ref} ) {
        $total_freq += $freq;
    }
    return $total_freq;
}

say "part 1: ", arrange_stones_after_blinks( 25, @input );
say "part 2: ", arrange_stones_after_blinks( 75, @input );
