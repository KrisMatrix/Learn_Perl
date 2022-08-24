#!/usr/bin/perl
use warnings;
use strict;
use experimental 'signatures';

package Person {
  sub new {
    my $class = shift;
    my $self = {
      age => 20,
      height => 160,
      weight => 180,
      gender => 'Male'
    };
    bless $self, $class;
    return $self;
  }

  sub get_age($self) {
    return $self->{age};
  }

  sub set_age($self, $age) {
    $self->{age} = $age;
    return $self->{age};
  }

  sub get_height($self) {
    return $self->{height};
  }

  sub set_height($self, $height) {
    $self->{height} = $height;
    return $self->{height};
  }

  sub get_weight($self) {
    return $self->{weight};
  }

  sub set_weight($self, $weight) {
    $self->{weight} = $weight;
    return $self->{weight};
  }

  sub get_gender($self) {
    return $self->{gender};
  }

  sub set_gender($self, $gender) {
    $self->{gender} = $gender;
    return $self->{gender};
  }
}


my $adam = Person->new();

print $adam->get_age(),"\n";
print $adam->set_age(25),"\n";
print $adam->get_height(),"\n";
print $adam->set_height(165),"\n";
print $adam->get_weight(),"\n";
print $adam->set_weight(155),"\n";
print $adam->get_gender(),"\n";
print $adam->set_gender("Female"),"\n";
