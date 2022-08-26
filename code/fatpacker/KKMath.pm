#!/usr/bin/perl
use warnings;
use strict;
use experimental 'signatures';

package KKMath {
  sub new {
    my $class = shift;
    my $self = {
      number => 0
    };
    bless $self, $class;
    return $self;
  }

  sub plus($self, $value) {
    $self->{number} += $value;
    return $self->{number};
  }

  sub minus($self, $value) {
    $self->{number} -= $value;
    return $self->{number};
  }
}

1;
