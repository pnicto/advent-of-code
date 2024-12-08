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
