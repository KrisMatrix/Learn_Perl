#!/usr/bin/perl
use warnings;
use strict;
use experimental 'signatures';

package Math {
  my $_pi = 3.1412;

  sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
  }

  sub get_pi($self) {
    return $_pi;
  }

  sub area_of_circle($self, $radius) {
    return 2*$_pi*$radius;
  }
}


my $obj = Math->new();

print $obj->get_pi(),"\n";
print $obj->area_of_circle(5),"\n";

print $obj->{$_pi},"\n";
