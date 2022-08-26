#!/usr/bin/perl
use warnings;
use strict;
use lib '.';
use KKMath;

my $obj = KKMath->new();
print $obj->plus(3),"\n";
print $obj->plus(2),"\n";
print $obj->plus(1),"\n";
print $obj->minus(3),"\n";
print $obj->minus(8),"\n";
