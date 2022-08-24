#!/usr/bin/perl
use warnings;
use strict;
use PDL;
use PDL::IO::CSV;

=pod

python equivalent 
# 1-dimensonal array, also referred to as a vector
a1 = np.array([1, 2, 3])

# 2-dimensional array, also referred to as matrix
a2 = np.array([[1, 2.0, 3.3],
               [4, 5, 6.5]])

# 3-dimensional array, also referred to as a matrix
a3 = np.array([[[1, 2, 3],
                [4, 5, 6],
                [7, 8, 9]],
                [[10, 11, 12],
                 [13, 14, 15],
                 [16, 17, 18]]])

=cut

my $a1 = pdl [1,2,3];
print "$a1\n";

my $a2 = pdl [[1,2.0,3.3],[4,5,6.5]];
print "$a2\n";

my $a3 = pdl [[[1, 2, 3],
               [4, 5, 6],
               [7, 8, 9]],
               [[10, 11, 12],
                [13, 14, 15],
                [16, 17, 18]]];
print "$a3\n";

=pod

a1.shape, a1.ndim, a1.dtype, a1.size, type(a1)
# ((3,), 1, dtype('int64'), 3, numpy.ndarray)

a2.shape, a2.ndim, a2.dtype, a2.size, type(a2)
((2, 3), 2, dtype('float64'), 6, numpy.ndarray)

a3.shape, a3.ndim, a3.dtype, a3.size, type(a3)
((2, 3, 3), 3, dtype('int64'), 18, numpy.ndarray)

=cut

=pod 

Creating arrays

  np.array([1,2,3])
  array([1, 2, 3])

  np.ones([3,3])
  array([[1., 1., 1.],
       [1., 1., 1.],
       [1., 1., 1.]])

  np.zeros([2,2])
  array([[0., 0.],
       [0., 0.]])

  np.random.randn(5,3)
  array([[ 1.30167635, -1.16893727,  0.03009681],
       [-0.36689988, -0.39158565, -0.84901229],
       [-1.32416057,  0.89195664, -1.20272039],
       [-1.68431053, -0.43624087,  1.00617851],
       [-1.68342667,  1.28352939, -0.35681544]])

  np.random.randint(10, size=5)
  array([4, 3, 3, 1, 8])

  np.random.seed(42)

=cut

my $a;
$a = pdl(1,2,3);
print "Array = $a\n";
$a = zeroes(3,3);
print "Zeroes = $a\n";
$a = ones(3,3);
print "Ones = $a\n";
$a = random(3,3);
print "Random = $a\n";
$a = sequence(10);
print "Sequence = $a\n";
$a = sequence(10)*2;
print "Sequence = $a\n";
$a = srand(42);
print "Srand = $a\n";

