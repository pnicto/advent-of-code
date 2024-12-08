use 5.010;
use strict;
use warnings;

use Data::Dump "dump";
use Path::Tiny;
use autodie;

my $file  = $ARGV[0];
my $input = path($file)->slurp;
