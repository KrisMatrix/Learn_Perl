#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Primitive;

our @EXPORT_OK = qw(inner outer matmult innerwt inner2 inner2d inner2t crossp norm indadd conv1d in uniq uniqind uniqvec hclip lclip clip clip wtstat statsover stats histogram whistogram histogram2d whistogram2d fibonacci append axisvalues cmpvec eqvec enumvec enumvecg vsearchvec unionvec intersectvec setdiffvec union_sorted intersect_sorted setdiff_sorted srand random randsym grandom vsearch vsearch_sample vsearch_insert_leftmost vsearch_insert_rightmost vsearch_match vsearch_bin_inclusive vsearch_bin_exclusive interpolate interpol interpND one2nd which which_both where where_both whereND whichND setops intersect );
our %EXPORT_TAGS = (Func=>\@EXPORT_OK);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;


   
   our @ISA = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Primitive ;






#line 6 "primitive.pd"

use strict;
use warnings;
use PDL::Slices;
use Carp;

{ package PDL;
  use overload (
    'x' => sub {
      PDL::Primitive::matmult(@_[0,1], my $foo=$_[0]->null());
      $foo;
    },
  );
}

=head1 NAME

PDL::Primitive - primitive operations for pdl

=head1 DESCRIPTION

This module provides some primitive and useful functions defined
using PDL::PP and able to use the new indexing tricks.

See L<PDL::Indexing> for how to use indices creatively.
For explanation of the signature format, see L<PDL::PP>.

=head1 SYNOPSIS

 # Pulls in PDL::Primitive, among other modules.
 use PDL;

 # Only pull in PDL::Primitive:
 use PDL::Primitive;

=cut
#line 62 "Primitive.pm"






=head1 FUNCTIONS

=cut




#line 948 "../../blib/lib/PDL/PP.pm"



=head2 inner

=for sig

  Signature: (a(n); b(n); [o]c())


=for ref

Inner product over one dimension

 c = sum_i a_i * b_i


=for bad

=for bad

If C<a() * b()> contains only bad data,
C<c()> is set bad. Otherwise C<c()> will have its bad flag cleared,
as it will not contain any bad values.


=cut
#line 104 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*inner = \&PDL::inner;
#line 111 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 outer

=for sig

  Signature: (a(n); b(m); [o]c(n,m))


=for ref

outer product over one dimension

Naturally, it is possible to achieve the effects of outer
product simply by broadcasting over the "C<*>"
operator but this function is provided for convenience.


=for bad

outer processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 142 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*outer = \&PDL::outer;
#line 149 "Primitive.pm"



#line 104 "primitive.pd"

=head2 x

=for sig

 Signature: (a(i,z), b(x,i),[o]c(x,z))

=for ref

Matrix multiplication

PDL overloads the C<x> operator (normally the repeat operator) for
matrix multiplication.  The number of columns (size of the 0
dimension) in the left-hand argument must normally equal the number of
rows (size of the 1 dimension) in the right-hand argument.

Row vectors are represented as (N x 1) two-dimensional PDLs, or you
may be sloppy and use a one-dimensional PDL.  Column vectors are
represented as (1 x N) two-dimensional PDLs.

Broadcasting occurs in the usual way, but as both the 0 and 1 dimension
(if present) are included in the operation, you must be sure that
you don't try to broadcast over either of those dims.

Of note, due to how Perl v5.14.0 and above implement operator overloading of
the C<x> operator, the use of parentheses for the left operand creates a list
context, that is

 pdl> ( $x * $y ) x $z
 ERROR: Argument "..." isn't numeric in repeat (x) ...

treats C<$z> as a numeric count for the list repeat operation and does not call
the scalar form of the overloaded operator. To use the operator in this case,
use a scalar context:

 pdl> scalar( $x * $y ) x $z

or by calling L</matmult> directly:

 pdl> ( $x * $y )->matmult( $z )

EXAMPLES

Here are some simple ways to define vectors and matrices:

 pdl> $r = pdl(1,2);                # A row vector
 pdl> $c = pdl([[3],[4]]);          # A column vector
 pdl> $c = pdl(3,4)->(*1);          # A column vector, using NiceSlice
 pdl> $m = pdl([[1,2],[3,4]]);      # A 2x2 matrix

Now that we have a few objects prepared, here is how to
matrix-multiply them:

 pdl> print $r x $m                 # row x matrix = row
 [
  [ 7 10]
 ]

 pdl> print $m x $r                 # matrix x row = ERROR
 PDL: Dim mismatch in matmult of [2x2] x [2x1]: 2 != 1

 pdl> print $m x $c                 # matrix x column = column
 [
  [ 5]
  [11]
 ]

 pdl> print $m x 2                  # Trivial case: scalar mult.
 [
  [2 4]
  [6 8]
 ]

 pdl> print $r x $c                 # row x column = scalar
 [
  [11]
 ]

 pdl> print $c x $r                 # column x row = matrix
 [
  [3 6]
  [4 8]
 ]

INTERNALS

The mechanics of the multiplication are carried out by the
L</matmult> method.

=cut
#line 244 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 matmult

=for sig

  Signature: (a(t,h); b(w,t); [o]c(w,h))

=for ref

Matrix multiplication

Notionally, matrix multiplication $x x $y is equivalent to the
broadcasting expression

    $x->dummy(1)->inner($y->xchg(0,1)->dummy(2),$c);

but for large matrices that breaks CPU cache and is slow.  Instead,
matmult calculates its result in 32x32x32 tiles, to keep the memory
footprint within cache as long as possible on most modern CPUs.

For usage, see L</x>, a description of the overloaded 'x' operator



=for bad

matmult ignores the bad-value flag of the input ndarrays.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 282 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

sub PDL::matmult {
    my ($x,$y,$c) = @_;
    $y = PDL->topdl($y);
    $c = PDL->null unless do { local $@; eval { $c->isa('PDL') } };
    while($x->getndims < 2) {$x = $x->dummy(-1)}
    while($y->getndims < 2) {$y = $y->dummy(-1)}
    return ($c .= $x * $y) if( ($x->dim(0)==1 && $x->dim(1)==1) ||
                               ($y->dim(0)==1 && $y->dim(1)==1) );
    barf sprintf 'Dim mismatch in matmult of [%1$dx%2$d] x [%3$dx%4$d]: %1$d != %4$d',$x->dim(0),$x->dim(1),$y->dim(0),$y->dim(1)
      if $y->dim(1) != $x->dim(0);
    PDL::_matmult_int($x,$y,$c);
    $c;
}
#line 301 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*matmult = \&PDL::matmult;
#line 308 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 innerwt

=for sig

  Signature: (a(n); b(n); c(n); [o]d())



=for ref

Weighted (i.e. triple) inner product

 d = sum_i a(i) b(i) c(i)



=for bad

innerwt processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 339 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*innerwt = \&PDL::innerwt;
#line 346 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 inner2

=for sig

  Signature: (a(n); b(n,m); c(m); [o]d())


=for ref

Inner product of two vectors and a matrix

 d = sum_ij a(i) b(i,j) c(j)

Note that you should probably not broadcast over C<a> and C<c> since that would be
very wasteful. Instead, you should use a temporary for C<b*c>.


=for bad

inner2 processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 378 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*inner2 = \&PDL::inner2;
#line 385 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 inner2d

=for sig

  Signature: (a(n,m); b(n,m); [o]c())



=for ref

Inner product over 2 dimensions.

Equivalent to

 $c = inner($x->clump(2), $y->clump(2))



=for bad

inner2d processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 418 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*inner2d = \&PDL::inner2d;
#line 425 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 inner2t

=for sig

  Signature: (a(j,n); b(n,m); c(m,k); [t]tmp(n,k); [o]d(j,k)))


=for ref

Efficient Triple matrix product C<a*b*c>

Efficiency comes from by using the temporary C<tmp>. This operation only
scales as C<N**3> whereas broadcasting using L</inner2> would scale
as C<N**4>.

The reason for having this routine is that you do not need to
have the same broadcast-dimensions for C<tmp> as for the other arguments,
which in case of large numbers of matrices makes this much more
memory-efficient.

It is hoped that things like this could be taken care of as a kind of
closures at some point.



=for bad

inner2t processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 465 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*inner2t = \&PDL::inner2t;
#line 472 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 crossp

=for sig

  Signature: (a(tri=3); b(tri); [o] c(tri))


=for ref

Cross product of two 3D vectors

After

=for example

 $c = crossp $x, $y

the inner product C<$c*$x> and C<$c*$y> will be zero, i.e. C<$c> is
orthogonal to C<$x> and C<$y>



=for bad

crossp does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 509 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*crossp = \&PDL::crossp;
#line 516 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 norm

=for sig

  Signature: (vec(n); [o] norm(n))

=for ref

Normalises a vector to unit Euclidean length

=for bad

norm processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 541 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*norm = \&PDL::norm;
#line 548 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 indadd

=for sig

  Signature: (input(n); indx ind(n); [io] sum(m))


=for ref

Broadcasting index add: add C<input> to the C<ind> element of C<sum>, i.e:

 sum(ind) += input

=for example

Simple example:

  $x = 2;
  $ind = 3;
  $sum = zeroes(10);
  indadd($x,$ind, $sum);
  print $sum
  #Result: ( 2 added to element 3 of $sum)
  # [0 0 0 2 0 0 0 0 0 0]

Broadcasting example:

  $x = pdl( 1,2,3);
  $ind = pdl( 1,4,6);
  $sum = zeroes(10);
  indadd($x,$ind, $sum);
  print $sum."\n";
  #Result: ( 1, 2, and 3 added to elements 1,4,6 $sum)
  # [0 1 0 0 2 0 3 0 0 0]



=for bad

=for bad

The routine barfs on bad indices, and bad inputs set target outputs bad.



=cut
#line 602 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*indadd = \&PDL::indadd;
#line 609 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 conv1d

=for sig

  Signature: (a(m); kern(p); [o]b(m); int reflect)


=for ref

1D convolution along first dimension

The m-th element of the discrete convolution of an input ndarray
C<$a> of size C<$M>, and a kernel ndarray C<$kern> of size C<$P>, is
calculated as

                              n = ($P-1)/2
                              ====
                              \
  ($a conv1d $kern)[m]   =     >      $a_ext[m - n] * $kern[n]
                              /
                              ====
                              n = -($P-1)/2

where C<$a_ext> is either the periodic (or reflected) extension of
C<$a> so it is equal to C<$a> on C< 0..$M-1 > and equal to the
corresponding periodic/reflected image of C<$a> outside that range.


=for example

  $con = conv1d sequence(10), pdl(-1,0,1);

  $con = conv1d sequence(10), pdl(-1,0,1), {Boundary => 'reflect'};

By default, periodic boundary conditions are assumed (i.e. wrap around).
Alternatively, you can request reflective boundary conditions using
the C<Boundary> option:

  {Boundary => 'reflect'} # case in 'reflect' doesn't matter

The convolution is performed along the first dimension. To apply it across
another dimension use the slicing routines, e.g.

  $y = $x->mv(2,0)->conv1d($kernel)->mv(0,2); # along third dim

This function is useful for broadcasted filtering of 1D signals.

Compare also L<conv2d|PDL::Image2D/conv2d>, L<convolve|PDL::ImageND/convolve>,
L<fftconvolve|PDL::FFT/fftconvolve()>, L<fftwconv|PDL::FFTW/fftwconv>,
L<rfftwconv|PDL::FFTW/rfftwconv>

=for bad

WARNING: C<conv1d> processes bad values in its inputs as
the numeric value of C<< $pdl->badvalue >> so it is not
recommended for processing pdls with bad values in them
unless special care is taken.



=for bad

conv1d ignores the bad-value flag of the input ndarrays.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 684 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"



sub PDL::conv1d {
   my $opt = pop @_ if ref($_[-1]) eq 'HASH';
   die 'Usage: conv1d( a(m), kern(p), [o]b(m), {Options} )'
      if @_<2 || @_>3;
   my($x,$kern) = @_;
   my $c = @_ == 3 ? $_[2] : PDL->null;
   PDL::_conv1d_int($x,$kern,$c,
		     !(defined $opt && exists $$opt{Boundary}) ? 0 :
		     lc $$opt{Boundary} eq "reflect");
   return $c;
}
#line 703 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*conv1d = \&PDL::conv1d;
#line 710 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 in

=for sig

  Signature: (a(); b(n); [o] c())


=for ref

test if a is in the set of values b

=for example

   $goodmsk = $labels->in($goodlabels);
   print pdl(3,1,4,6,2)->in(pdl(2,3,3));
  [1 0 0 0 1]

C<in> is akin to the I<is an element of> of set theory. In principle,
PDL broadcasting could be used to achieve its functionality by using a
construct like

   $msk = ($labels->dummy(0) == $goodlabels)->orover;

However, C<in> doesn't create a (potentially large) intermediate
and is generally faster.



=for bad

in does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 753 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*in = \&PDL::in;
#line 760 "Primitive.pm"



#line 697 "primitive.pd"

=head2 uniq

=for ref

return all unique elements of an ndarray

The unique elements are returned in ascending order.

=for example

  PDL> p pdl(2,2,2,4,0,-1,6,6)->uniq
  [-1 0 2 4 6]     # 0 is returned 2nd (sorted order)

  PDL> p pdl(2,2,2,4,nan,-1,6,6)->uniq
  [-1 2 4 6 nan]   # NaN value is returned at end

Note: The returned pdl is 1D; any structure of the input
ndarray is lost.  C<NaN> values are never compare equal to
any other values, even themselves.  As a result, they are
always unique. C<uniq> returns the NaN values at the end
of the result ndarray.  This follows the Matlab usage.

See L</uniqind> if you need the indices of the unique
elements rather than the values.

=for bad

Bad values are not considered unique by uniq and are ignored.

 $x=sequence(10);
 $x=$x->setbadif($x%3);
 print $x->uniq;
 [0 3 6 9]

=cut

*uniq = \&PDL::uniq;
# return unique elements of array
# find as jumps in the sorted array
# flattens in the process
sub PDL::uniq {
   use PDL::Core 'barf';
   my ($arr) = @_;
   return $arr if($arr->nelem == 0); # The null list is unique (CED)
   my $srt  = $arr->clump(-1)->where($arr==$arr)->qsort;  # no NaNs or BADs for qsort
   my $nans = $arr->clump(-1)->where($arr!=$arr);
   my $uniq = ($srt->nelem > 0) ? $srt->where($srt != $srt->rotate(-1)) : $srt;
   # make sure we return something if there is only one value
   my $answ = $nans;  # NaN values always uniq
   if ( $uniq->nelem > 0 ) {
      $answ = $uniq->append($answ);
   } else {
      $answ = ( ($srt->nelem == 0) ?  $srt : PDL::pdl( ref($srt), [$srt->index(0)] ) )->append($answ);
   }
   return $answ;
}
#line 822 "Primitive.pm"



#line 757 "primitive.pd"

=head2 uniqind

=for ref

Return the indices of all unique elements of an ndarray
The order is in the order of the values to be consistent
with uniq. C<NaN> values never compare equal with any
other value and so are always unique.  This follows the
Matlab usage.

=for example

  PDL> p pdl(2,2,2,4,0,-1,6,6)->uniqind
  [5 4 1 3 6]     # the 0 at index 4 is returned 2nd, but...

  PDL> p pdl(2,2,2,4,nan,-1,6,6)->uniqind
  [5 1 3 6 4]     # ...the NaN at index 4 is returned at end


Note: The returned pdl is 1D; any structure of the input
ndarray is lost.

See L</uniq> if you want the unique values instead of the
indices.

=for bad

Bad values are not considered unique by uniqind and are ignored.

=cut

*uniqind = \&PDL::uniqind;
# return unique elements of array
# find as jumps in the sorted array
# flattens in the process
sub PDL::uniqind {
  use PDL::Core 'barf';
  my ($arr) = @_;
  return $arr if($arr->nelem == 0); # The null list is unique (CED)
  # Different from uniq we sort and store the result in an intermediary
  my $aflat = $arr->flat;
  my $nanind = which($aflat!=$aflat);                        # NaN indexes
  my $good = PDL->sequence(indx, $aflat->dims)->where($aflat==$aflat);  # good indexes
  my $i_srt = $aflat->where($aflat==$aflat)->qsorti;         # no BAD or NaN values for qsorti
  my $srt = $aflat->where($aflat==$aflat)->index($i_srt);
  my $uniqind;
  if ($srt->nelem > 0) {
     $uniqind = which($srt != $srt->rotate(-1));
     $uniqind = $i_srt->slice('0') if $uniqind->isempty;
  } else {
     $uniqind = which($srt);
  }
  # Now map back to the original space
  my $ansind = $nanind;
  if ( $uniqind->nelem > 0 ) {
     $ansind = ($good->index($i_srt->index($uniqind)))->append($ansind);
  } else {
     $ansind = $uniqind->append($ansind);
  }
  return $ansind;
}
#line 889 "Primitive.pm"



#line 823 "primitive.pd"

=head2 uniqvec

=for ref

Return all unique vectors out of a collection

  NOTE: If any vectors in the input ndarray have NaN values
  they are returned at the end of the non-NaN ones.  This is
  because, by definition, NaN values never compare equal with
  any other value.

  NOTE: The current implementation does not sort the vectors
  containing NaN values.

The unique vectors are returned in lexicographically sorted
ascending order. The 0th dimension of the input PDL is treated
as a dimensional index within each vector, and the 1st and any
higher dimensions are taken to run across vectors. The return
value is always 2D; any structure of the input PDL (beyond using
the 0th dimension for vector index) is lost.

See also L</uniq> for a unique list of scalars; and
L<qsortvec|PDL::Ufunc/qsortvec> for sorting a list of vectors
lexicographcally.

=for bad

If a vector contains all bad values, it is ignored as in L</uniq>.
If some of the values are good, it is treated as a normal vector. For
example, [1 2 BAD] and [BAD 2 3] could be returned, but [BAD BAD BAD]
could not.  Vectors containing BAD values will be returned after any
non-NaN and non-BAD containing vectors, followed by the NaN vectors.

=cut

sub PDL::uniqvec {
   my($pdl) = shift;

   return $pdl if ( $pdl->nelem == 0 || $pdl->ndims < 2 );
   return $pdl if ( $pdl->slice("(0)")->nelem < 2 );                     # slice isn't cheap but uniqvec isn't either

   my $pdl2d = $pdl->clump(1..$pdl->ndims-1);
   my $ngood = $pdl2d->ngoodover;
   $pdl2d = $pdl2d->mv(0,-1)->dice($ngood->which)->mv(-1,0);             # remove all-BAD vectors

   my $numnan = ($pdl2d!=$pdl2d)->sumover;                                  # works since no all-BADs to confuse

   my $presrt = $pdl2d->mv(0,-1)->dice($numnan->not->which)->mv(0,-1);      # remove vectors with any NaN values
   my $nanvec = $pdl2d->mv(0,-1)->dice($numnan->which)->mv(0,-1);           # the vectors with any NaN values

   my $srt = $presrt->qsortvec->mv(0,-1);                                   # BADs are sorted by qsortvec
   my $srtdice = $srt;
   my $somebad = null;
   if ($srt->badflag) {
      $srtdice = $srt->dice($srt->mv(0,-1)->nbadover->not->which);
      $somebad = $srt->dice($srt->mv(0,-1)->nbadover->which);
   }

   my $uniq = $srtdice->nelem > 0
     ? ($srtdice != $srtdice->rotate(-1))->mv(0,-1)->orover->which
     : $srtdice->orover->which;

   my $ans = $uniq->nelem > 0 ? $srtdice->dice($uniq) :
      ($srtdice->nelem > 0) ? $srtdice->slice("0,:") :
      $srtdice;
   return $ans->append($somebad)->append($nanvec->mv(0,-1))->mv(0,-1);
}
#line 962 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 hclip

=for sig

  Signature: (a(); b(); [o] c())

=for ref

clip (threshold) C<$a> by C<$b> (C<$b> is upper bound)

=for bad

hclip processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 987 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

sub PDL::hclip {
   my ($x,$y) = @_;
   my $c;
   if ($x->is_inplace) {
       $x->set_inplace(0); $c = $x;
   } elsif (@_ > 2) {$c=$_[2]} else {$c=PDL->nullcreate($x)}
   PDL::_hclip_int($x,$y,$c);
   return $c;
}
#line 1002 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*hclip = \&PDL::hclip;
#line 1009 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 lclip

=for sig

  Signature: (a(); b(); [o] c())

=for ref

clip (threshold) C<$a> by C<$b> (C<$b> is lower bound)

=for bad

lclip processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1034 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

sub PDL::lclip {
   my ($x,$y) = @_;
   my $c;
   if ($x->is_inplace) {
       $x->set_inplace(0); $c = $x;
   } elsif (@_ > 2) {$c=$_[2]} else {$c=PDL->nullcreate($x)}
   PDL::_lclip_int($x,$y,$c);
   return $c;
}
#line 1049 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*lclip = \&PDL::lclip;
#line 1056 "Primitive.pm"



#line 933 "primitive.pd"

=head2 clip

=for ref

Clip (threshold) an ndarray by (optional) upper or lower bounds.

=for usage

 $y = $x->clip(0,3);
 $c = $x->clip(undef, $x);

=for bad

clip handles bad values since it is just a
wrapper around L</hclip> and
L</lclip>.

=cut
#line 1080 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 clip

=for sig

  Signature: (a(); l(); h(); [o] c())


=for ref

info not available


=for bad

clip processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1107 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

*clip = \&PDL::clip;
sub PDL::clip {
  my($x, $l, $h) = @_;
  my $d;
  unless(defined($l) || defined($h)) {
      # Deal with pathological case
      if($x->is_inplace) {
	  $x->set_inplace(0);
	  return $x;
      } else {
	  return $x->copy;
      }
  }

  if($x->is_inplace) {
      $x->set_inplace(0); $d = $x
  } elsif (@_ > 3) {
      $d=$_[3]
  } else {
      $d = PDL->nullcreate($x);
  }
  if(defined($l) && defined($h)) {
      PDL::_clip_int($x,$l,$h,$d);
  } elsif( defined($l) ) {
      PDL::_lclip_int($x,$l,$d);
  } elsif( defined($h) ) {
      PDL::_hclip_int($x,$h,$d);
  } else {
      die "This can't happen (clip contingency) - file a bug";
  }

  return $d;
}
#line 1146 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*clip = \&PDL::clip;
#line 1153 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 wtstat

=for sig

  Signature: (a(n); wt(n); avg(); [o]b(); int deg)


=for ref

Weighted statistical moment of given degree

This calculates a weighted statistic over the vector C<a>.
The formula is

 b() = (sum_i wt_i * (a_i ** degree - avg)) / (sum_i wt_i)


=for bad

=for bad

Bad values are ignored in any calculation; C<$b> will only
have its bad flag set if the output contains any bad data.


=cut
#line 1187 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*wtstat = \&PDL::wtstat;
#line 1194 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 statsover

=for sig

  Signature: (a(n); w(n); float+ [o]avg(); float+ [o]prms(); int+ [o]median(); int+ [o]min(); int+ [o]max(); float+ [o]adev(); float+ [o]rms())


=for ref

Calculate useful statistics over a dimension of an ndarray

=for usage

  ($mean,$prms,$median,$min,$max,$adev,$rms) = statsover($ndarray, $weights);

This utility function calculates various useful
quantities of an ndarray. These are:

=over 3

=item * the mean:

  MEAN = sum (x)/ N

with C<N> being the number of elements in x

=item * the population RMS deviation from the mean:

  PRMS = sqrt( sum( (x-mean(x))^2 )/(N-1)

The population deviation is the best-estimate of the deviation
of the population from which a sample is drawn.

=item * the median

The median is the 50th percentile data value.  Median is found by
L<medover|PDL::Ufunc/medover>, so WEIGHTING IS IGNORED FOR THE MEDIAN CALCULATION.

=item * the minimum

=item * the maximum

=item * the average absolute deviation:

  AADEV = sum( abs(x-mean(x)) )/N

=item * RMS deviation from the mean:

  RMS = sqrt(sum( (x-mean(x))^2 )/N)

(also known as the root-mean-square deviation, or the square root of the
variance)

=back

This operator is a projection operator so the calculation
will take place over the final dimension. Thus if the input
is N-dimensional each returned value will be N-1 dimensional,
to calculate the statistics for the entire ndarray either
use C<clump(-1)> directly on the ndarray or call C<stats>.



=for bad

=for bad

Bad values are simply ignored in the calculation, effectively reducing
the sample size.  If all data are bad then the output data are marked bad.



=cut
#line 1275 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


sub PDL::statsover {
   barf('Usage: ($mean,[$prms, $median, $min, $max, $adev, $rms]) = statsover($data,[$weights])') if @_>2;
   my ($data, $weights) = @_;
   $weights //= $data->ones();
   my $median = $data->medover;
   my $mean = PDL->nullcreate($data);
   my $rms = PDL->nullcreate($data);
   my $min = PDL->nullcreate($data);
   my $max = PDL->nullcreate($data);
   my $adev = PDL->nullcreate($data);
   my $prms = PDL->nullcreate($data);
   PDL::_statsover_int($data, $weights, $mean, $prms, $median, $min, $max, $adev, $rms);
   wantarray ? ($mean, $prms, $median, $min, $max, $adev, $rms) : $mean;
}
#line 1296 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*statsover = \&PDL::statsover;
#line 1303 "Primitive.pm"



#line 1184 "primitive.pd"

=head2 stats

=for ref

Calculates useful statistics on an ndarray

=for usage

 ($mean,$prms,$median,$min,$max,$adev,$rms) = stats($ndarray,[$weights]);

This utility calculates all the most useful quantities in one call.
It works the same way as L</statsover>, except that the quantities are
calculated considering the entire input PDL as a single sample, rather
than as a collection of rows. See L</statsover> for definitions of the
returned quantities.

=for bad

Bad values are handled; if all input values are bad, then all of the output
values are flagged bad.

=cut

*stats	  = \&PDL::stats;
sub PDL::stats {
    barf('Usage: ($mean,[$rms]) = stats($data,[$weights])') if @_>2;
    my ($data,$weights) = @_;

    # Ensure that $weights is properly broadcasted over; this could be
    # done rather more efficiently...
    if(defined $weights) {
	$weights = pdl($weights) unless UNIVERSAL::isa($weights,'PDL');
	if( ($weights->ndims != $data->ndims) or
	    (pdl($weights->dims) != pdl($data->dims))->or
	  ) {
		$weights = $weights + zeroes($data)
	}
	$weights = $weights->flat;
    }

    return PDL::statsover($data->flat,$weights);
}
#line 1351 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 histogram

=for sig

  Signature: (in(n); int+[o] hist(m); double step; double min; int msize => m)

=for ref

Calculates a histogram for given stepsize and minimum.

=for usage

 $h = histogram($data, $step, $min, $numbins);
 $hist = zeroes $numbins;  # Put histogram in existing ndarray.
 histogram($data, $hist, $step, $min, $numbins);

The histogram will contain C<$numbins> bins starting from C<$min>, each
C<$step> wide. The value in each bin is the number of
values in C<$data> that lie within the bin limits.


Data below the lower limit is put in the first bin, and data above the
upper limit is put in the last bin.

The output is reset in a different broadcastloop so that you
can take a histogram of C<$a(10,12)> into C<$b(15)> and get the result
you want.

For a higher-level interface, see L<hist|PDL::Basic/hist>.

=for example

 pdl> p histogram(pdl(1,1,2),1,0,3)
 [0 2 1]



=for bad

histogram processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1403 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*histogram = \&PDL::histogram;
#line 1410 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 whistogram

=for sig

  Signature: (in(n); float+ wt(n);float+[o] hist(m); double step; double min; int msize => m)

=for ref

Calculates a histogram from weighted data for given stepsize and minimum.

=for usage

 $h = whistogram($data, $weights, $step, $min, $numbins);
 $hist = zeroes $numbins;  # Put histogram in existing ndarray.
 whistogram($data, $weights, $hist, $step, $min, $numbins);

The histogram will contain C<$numbins> bins starting from C<$min>, each
C<$step> wide. The value in each bin is the sum of the values in C<$weights>
that correspond to values in C<$data> that lie within the bin limits.

Data below the lower limit is put in the first bin, and data above the
upper limit is put in the last bin.

The output is reset in a different broadcastloop so that you
can take a histogram of C<$a(10,12)> into C<$b(15)> and get the result
you want.

=for example

 pdl> p whistogram(pdl(1,1,2), pdl(0.1,0.1,0.5), 1, 0, 4)
 [0 0.2 0.5 0]



=for bad

whistogram processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1459 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*whistogram = \&PDL::whistogram;
#line 1466 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 histogram2d

=for sig

  Signature: (ina(n); inb(n); int+[o] hist(ma,mb); double stepa; double mina; int masize => ma;
	             double stepb; double minb; int mbsize => mb;)

=for ref

Calculates a 2d histogram.

=for usage

 $h = histogram2d($datax, $datay, $stepx, $minx,
       $nbinx, $stepy, $miny, $nbiny);
 $hist = zeroes $nbinx, $nbiny;  # Put histogram in existing ndarray.
 histogram2d($datax, $datay, $hist, $stepx, $minx,
       $nbinx, $stepy, $miny, $nbiny);

The histogram will contain C<$nbinx> x C<$nbiny> bins, with the lower
limits of the first one at C<($minx, $miny)>, and with bin size
C<($stepx, $stepy)>.
The value in each bin is the number of
values in C<$datax> and C<$datay> that lie within the bin limits.

Data below the lower limit is put in the first bin, and data above the
upper limit is put in the last bin.

=for example

 pdl> p histogram2d(pdl(1,1,1,2,2),pdl(2,1,1,1,1),1,0,3,1,0,3)
 [
  [0 0 0]
  [0 2 2]
  [0 1 0]
 ]



=for bad

histogram2d processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1520 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*histogram2d = \&PDL::histogram2d;
#line 1527 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 whistogram2d

=for sig

  Signature: (ina(n); inb(n); float+ wt(n);float+[o] hist(ma,mb); double stepa; double mina; int masize => ma;
	             double stepb; double minb; int mbsize => mb;)

=for ref

Calculates a 2d histogram from weighted data.

=for usage

 $h = whistogram2d($datax, $datay, $weights,
       $stepx, $minx, $nbinx, $stepy, $miny, $nbiny);
 $hist = zeroes $nbinx, $nbiny;  # Put histogram in existing ndarray.
 whistogram2d($datax, $datay, $weights, $hist,
       $stepx, $minx, $nbinx, $stepy, $miny, $nbiny);

The histogram will contain C<$nbinx> x C<$nbiny> bins, with the lower
limits of the first one at C<($minx, $miny)>, and with bin size
C<($stepx, $stepy)>.
The value in each bin is the sum of the values in
C<$weights> that correspond to values in C<$datax> and C<$datay> that lie within the bin limits.

Data below the lower limit is put in the first bin, and data above the
upper limit is put in the last bin.

=for example

 pdl> p whistogram2d(pdl(1,1,1,2,2),pdl(2,1,1,1,1),pdl(0.1,0.2,0.3,0.4,0.5),1,0,3,1,0,3)
 [
  [  0   0   0]
  [  0 0.5 0.9]
  [  0 0.1   0]
 ]



=for bad

whistogram2d processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1581 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*whistogram2d = \&PDL::whistogram2d;
#line 1588 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 fibonacci

=for sig

  Signature: (i(n); indx [o]x(n))

=for ref

Constructor - a vector with Fibonacci's sequence

=for bad

fibonacci does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1613 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

sub fibonacci { ref($_[0]) && ref($_[0]) ne 'PDL::Type' ? $_[0]->fibonacci : PDL->fibonacci(@_) }
sub PDL::fibonacci{
   my $x = &PDL::Core::_construct;
   my $is_inplace = $x->is_inplace;
   my ($in, $out) = $x->clump(-1);
   $out = $is_inplace ? $in->inplace : PDL->null;
   PDL::_fibonacci_int($in, $out);
   $out;
}
#line 1628 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"
#line 1633 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 append

=for sig

  Signature: (a(n); b(m); [o] c(mn))


=for ref

append two ndarrays by concatenating along their first dimensions

=for example

 $x = ones(2,4,7);
 $y = sequence 5;
 $c = $x->append($y);  # size of $c is now (7,4,7) (a jumbo-ndarray ;)

C<append> appends two ndarrays along their first dimensions. The rest of the
dimensions must be compatible in the broadcasting sense. The resulting
size of the first dimension is the sum of the sizes of the first dimensions
of the two argument ndarrays - i.e. C<n + m>.

Similar functions include L</glue> (below), which can append more
than two ndarrays along an arbitrary dimension, and
L<cat|PDL::Core/cat>, which can append more than two ndarrays that all
have the same sized dimensions.


=for bad

append does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1676 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


#line 1496 "primitive.pd"

sub PDL::append {
  my ($i1, $i2, $o) = map PDL->topdl($_), @_;
  if (grep $_->isempty, $i1, $i2) {
    if (!defined $o) {
      return $i2->isnull ? PDL->zeroes(0) : $i2->copy if $i1->isempty;
      return $i1->isnull ? PDL->zeroes(0) : $i1->copy;
    } else {
      $o .= $i2->isnull ? PDL->zeroes(0) : $i2, return $o if $i1->isempty;
      $o .= $i1->isnull ? PDL->zeroes(0) : $i1, return $o;
    }
  }
  $o //= PDL->null;
  PDL::_append_int($i1, $i2->convert($i1->type), $o);
  $o;
}
        
#line 969 "../../blib/lib/PDL/PP.pm"
#line 1702 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*append = \&PDL::append;
#line 1709 "Primitive.pm"



#line 1543 "primitive.pd"

=head2 glue

=for usage

  $c = $x->glue(<dim>,$y,...)

=for ref

Glue two or more PDLs together along an arbitrary dimension
(N-D L</append>).

Sticks $x, $y, and all following arguments together along the
specified dimension.  All other dimensions must be compatible in the
broadcasting sense.

Glue is permissive, in the sense that every PDL is treated as having an
infinite number of trivial dimensions of order 1 -- so C<< $x->glue(3,$y) >>
works, even if $x and $y are only one dimensional.

If one of the PDLs has no elements, it is ignored.  Likewise, if one
of them is actually the undefined value, it is treated as if it had no
elements.

If the first parameter is a defined perl scalar rather than a pdl,
then it is taken as a dimension along which to glue everything else,
so you can say C<$cube = PDL::glue(3,@image_list);> if you like.

C<glue> is implemented in pdl, using a combination of L<xchg|PDL::Slices/xchg> and
L</append>.  It should probably be updated (one day) to a pure PP
function.

Similar functions include L</append> (above), which appends
only two ndarrays along their first dimension, and
L<cat|PDL::Core/cat>, which can append more than two ndarrays that all
have the same sized dimensions.

=cut

sub PDL::glue{
    my($x) = shift;
    my($dim) = shift;

    ($dim, $x) = ($x, $dim) if defined $x && !ref $x;
    confess 'dimension must be Perl scalar' if ref $dim;

    if(!defined $x || $x->nelem==0) {
	return $x unless(@_);
	return shift() if(@_<=1);
	$x=shift;
	return PDL::glue($x,$dim,@_);
    }

    if($dim - $x->dim(0) > 100) {
	print STDERR "warning:: PDL::glue allocating >100 dimensions!\n";
    }
    while($dim >= $x->ndims) {
	$x = $x->dummy(-1,1);
    }
    $x = $x->xchg(0,$dim);

    while(scalar(@_)){
	my $y = shift;
	next unless(defined $y && $y->nelem);

	while($dim >= $y->ndims) {
		$y = $y->dummy(-1,1);
        }
	$y = $y->xchg(0,$dim);
	$x = $x->append($y);
    }
    $x->xchg(0,$dim);
}
#line 1787 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*axisvalues = \&PDL::axisvalues;
#line 1794 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 cmpvec

=for sig

  Signature: (a(n); b(n); sbyte [o]c())


=for ref

Compare two vectors lexicographically.

Returns -1 if a is less, 1 if greater, 0 if equal.


=for bad

The output is bad if any input values up to the point of inequality are
bad - any after are ignored.


=cut
#line 1823 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*cmpvec = \&PDL::cmpvec;
#line 1830 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 eqvec

=for sig

  Signature: (a(n); b(n); sbyte [o]c())


=for ref

Compare two vectors, returning 1 if equal, 0 if not equal.


=for bad

The output is bad if any input values are bad.

=cut
#line 1855 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*eqvec = \&PDL::eqvec;
#line 1862 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 enumvec

=for sig

  Signature: (v(M,N); indx [o]k(N))

=for ref

Enumerate a list of vectors with locally unique keys.

Given a sorted list of vectors $v, generate a vector $k containing locally unique keys for the elements of $v
(where an "element" is a vector of length $M ocurring in $v).

Note that the keys returned in $k are only unique over a run of a single vector in $v,
so that each unique vector in $v has at least one 0 (zero) index in $k associated with it.
If you need global keys, see enumvecg().

Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

enumvec does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1897 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*enumvec = \&PDL::enumvec;
#line 1904 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 enumvecg

=for sig

  Signature: (v(M,N); indx [o]k(N))

=for ref

Enumerate a list of vectors with globally unique keys.

Given a sorted list of vectors $v, generate a vector $k containing globally unique keys for the elements of $v
(where an "element" is a vector of length $M ocurring in $v).
Basically does the same thing as:

 $k = $v->vsearchvec($v->uniqvec);

... but somewhat more efficiently.

Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

enumvecg does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1940 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*enumvecg = \&PDL::enumvecg;
#line 1947 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 vsearchvec

=for sig

  Signature: (find(M); which(M,N); indx [o]found())

=for ref

Routine for searching N-dimensional values - akin to vsearch() for vectors.

=for usage

 $found   = vsearchvec($find, $which);
 $nearest = $which->dice_axis(1,$found);

Returns for each row-vector in C<$find> the index along dimension N
of the least row vector of C<$which>
greater or equal to it.
C<$which> should be sorted in increasing order.
If the value of C<$find> is larger
than any member of C<$which>, the index to the last element of C<$which> is
returned.

See also: L</vsearch>.
Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

vsearchvec does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1989 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*vsearchvec = \&PDL::vsearchvec;
#line 1996 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 unionvec

=for sig

  Signature: (a(M,NA); b(M,NB); [o]c(M,NC); indx [o]nc())

=for ref

Union of two vector-valued PDLs.

Input PDLs $a() and $b() B<MUST> be sorted in lexicographic order.
On return, $nc() holds the actual number of vector-values in the union.

In scalar context, slices $c() to the actual number of elements in the union
and returns the sliced PDL.

Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

unionvec does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2030 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


 sub PDL::unionvec {
   my ($a,$b,$c,$nc) = @_;
   $c = PDL->null if (!defined($nc));
   $nc = PDL->null if (!defined($nc));
   PDL::_unionvec_int($a,$b,$c,$nc);
   return ($c,$nc) if (wantarray);
   return $c->slice(",0:".($nc->max-1));
 }
#line 2045 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*unionvec = \&PDL::unionvec;
#line 2052 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 intersectvec

=for sig

  Signature: (a(M,NA); b(M,NB); [o]c(M,NC); indx [o]nc())

=for ref

Intersection of two vector-valued PDLs.
Input PDLs $a() and $b() B<MUST> be sorted in lexicographic order.
On return, $nc() holds the actual number of vector-values in the intersection.

In scalar context, slices $c() to the actual number of elements in the intersection
and returns the sliced PDL.

Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

intersectvec does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2085 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


 sub PDL::intersectvec {
   my ($a,$b,$c,$nc) = @_;
   $c = PDL->null if (!defined($c));
   $nc = PDL->null if (!defined($nc));
   PDL::_intersectvec_int($a,$b,$c,$nc);
   return ($c,$nc) if (wantarray);
   my $nc_max = $nc->max;
   return ($nc_max > 0
	   ? $c->slice(",0:".($nc_max-1))
	   : $c->reshape($c->dim(0), 0, ($c->dims)[2..($c->ndims-1)]));
 }
#line 2103 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*intersectvec = \&PDL::intersectvec;
#line 2110 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 setdiffvec

=for sig

  Signature: (a(M,NA); b(M,NB); [o]c(M,NC); indx [o]nc())

=for ref

Set-difference ($a() \ $b()) of two vector-valued PDLs.

Input PDLs $a() and $b() B<MUST> be sorted in lexicographic order.
On return, $nc() holds the actual number of vector-values in the computed vector set.

In scalar context, slices $c() to the actual number of elements in the output vector set
and returns the sliced PDL.

Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

setdiffvec does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2144 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


 sub PDL::setdiffvec {
  my ($a,$b,$c,$nc) = @_;
  $c = PDL->null if (!defined($c));
  $nc = PDL->null if (!defined($nc));
  PDL::_setdiffvec_int($a,$b,$c,$nc);
  return ($c,$nc) if (wantarray);
  my $nc_max = $nc->max;
  return ($nc_max > 0
	  ? $c->slice(",0:".($nc_max-1))
	  : $c->reshape($c->dim(0), 0, ($c->dims)[2..($c->ndims-1)]));
 }
#line 2162 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*setdiffvec = \&PDL::setdiffvec;
#line 2169 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 union_sorted

=for sig

  Signature: (a(NA); b(NB); [o]c(NC); indx [o]nc())

=for ref

Union of two flat sorted unique-valued PDLs.
Input PDLs $a() and $b() B<MUST> be sorted in lexicographic order and contain no duplicates.
On return, $nc() holds the actual number of values in the union.

In scalar context, reshapes $c() to the actual number of elements in the union and returns it.

Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

union_sorted does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2201 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


 sub PDL::union_sorted {
   my ($a,$b,$c,$nc) = @_;
   $c = PDL->null if (!defined($c));
   $nc = PDL->null if (!defined($nc));
   PDL::_union_sorted_int($a,$b,$c,$nc);
   return ($c,$nc) if (wantarray);
   return $c->slice("0:".($nc->max-1));
 }
#line 2216 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*union_sorted = \&PDL::union_sorted;
#line 2223 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 intersect_sorted

=for sig

  Signature: (a(NA); b(NB); [o]c(NC); indx [o]nc())

=for ref

Intersection of two flat sorted unique-valued PDLs.
Input PDLs $a() and $b() B<MUST> be sorted in lexicographic order and contain no duplicates.
On return, $nc() holds the actual number of values in the intersection.

In scalar context, reshapes $c() to the actual number of elements in the intersection and returns it.

Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

intersect_sorted does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2255 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


 sub PDL::intersect_sorted {
   my ($a,$b,$c,$nc) = @_;
   $c = PDL->null if (!defined($c));
   $nc = PDL->null if (!defined($nc));
   PDL::_intersect_sorted_int($a,$b,$c,$nc);
   return ($c,$nc) if (wantarray);
   my $nc_max = $nc->max;
   return ($nc_max > 0
	   ? $c->slice("0:".($nc_max-1))
	   : $c->reshape(0, ($c->dims)[1..($c->ndims-1)]));
 }
#line 2273 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*intersect_sorted = \&PDL::intersect_sorted;
#line 2280 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 setdiff_sorted

=for sig

  Signature: (a(NA); b(NB); [o]c(NC); indx [o]nc())

=for ref

Set-difference ($a() \ $b()) of two flat sorted unique-valued PDLs.

Input PDLs $a() and $b() B<MUST> be sorted in lexicographic order and contain no duplicate values.
On return, $nc() holds the actual number of values in the computed vector set.

In scalar context, reshapes $c() to the actual number of elements in the difference set and returns it.

Contributed by Bryan Jurish E<lt>moocow@cpan.orgE<gt>.


=for bad

setdiff_sorted does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2313 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


 sub PDL::setdiff_sorted {
   my ($a,$b,$c,$nc) = @_;
   $c = PDL->null if (!defined($c));
   $nc = PDL->null if (!defined($nc));
   PDL::_setdiff_sorted_int($a,$b,$c,$nc);
   return ($c,$nc) if (wantarray);
   my $nc_max = $nc->max;
   return ($nc_max > 0
	   ? $c->slice("0:".($nc_max-1))
	   : $c->reshape(0, ($c->dims)[1..($c->ndims-1)]));
 }
#line 2331 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*setdiff_sorted = \&PDL::setdiff_sorted;
#line 2338 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 srand

=for sig

  Signature: (a())

=for ref

Seed random-number generator with a 64-bit int. Will generate seed data
for a number of threads equal to the return-value of
L<PDL::Core/online_cpus>.

=for usage

 srand(); # uses current time
 srand(5); # fixed number e.g. for testing



=for bad

srand does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2372 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

*srand = \&PDL::srand;
sub PDL::srand { PDL::_srand_int($_[0] // PDL::Core::seed()) }
#line 2380 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*srand = \&PDL::srand;
#line 2387 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 random

=for sig

  Signature: (a())

=for ref

Constructor which returns ndarray of random numbers

=for usage

 $x = random([type], $nx, $ny, $nz,...);
 $x = random $y;

etc (see L<zeroes|PDL::Core/zeroes>).

This is the uniform distribution between 0 and 1 (assumedly
excluding 1 itself). The arguments are the same as C<zeroes>
(q.v.) - i.e. one can specify dimensions, types or give
a template.

You can use the PDL function L</srand> to seed the random generator.
If it has not been called yet, it will be with the current time.


=for bad

random does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2428 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

sub random { ref($_[0]) && ref($_[0]) ne 'PDL::Type' ? $_[0]->random : PDL->random(@_) }
sub PDL::random {
   my $class = shift;
   my $x = scalar(@_)? $class->new_from_specification(@_) : $class->new_or_inplace;
   PDL::_random_int($x);
   return $x;
}
#line 2441 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"
#line 2446 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 randsym

=for sig

  Signature: (a())

=for ref

Constructor which returns ndarray of random numbers

=for usage

 $x = randsym([type], $nx, $ny, $nz,...);
 $x = randsym $y;

etc (see L<zeroes|PDL::Core/zeroes>).

This is the uniform distribution between 0 and 1 (excluding both 0 and
1, cf L</random>). The arguments are the same as C<zeroes> (q.v.) -
i.e. one can specify dimensions, types or give a template.

You can use the PDL function L</srand> to seed the random generator.
If it has not been called yet, it will be with the current time.


=for bad

randsym does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2486 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

sub randsym { ref($_[0]) && ref($_[0]) ne 'PDL::Type' ? $_[0]->randsym : PDL->randsym(@_) }
sub PDL::randsym {
   my $class = shift;
   my $x = scalar(@_)? $class->new_from_specification(@_) : $class->new_or_inplace;
   PDL::_randsym_int($x);
   return $x;
}
#line 2499 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"
#line 2504 "Primitive.pm"



#line 2318 "primitive.pd"

=head2 grandom

=for ref

Constructor which returns ndarray of Gaussian random numbers

=for usage

 $x = grandom([type], $nx, $ny, $nz,...);
 $x = grandom $y;

etc (see L<zeroes|PDL::Core/zeroes>).

This is generated using the math library routine C<ndtri>.

Mean = 0, Stddev = 1

You can use the PDL function L</srand> to seed the random generator.
If it has not been called yet, it will be with the current time.

=cut

sub grandom { ref($_[0]) && ref($_[0]) ne 'PDL::Type' ? $_[0]->grandom : PDL->grandom(@_) }
sub PDL::grandom {
   my $class = shift;
   my $x = scalar(@_)? $class->new_from_specification(@_) : $class->new_or_inplace;
   use PDL::Math 'ndtri';
   $x .= ndtri(randsym($x));
   return $x;
}
#line 2540 "Primitive.pm"



#line 2358 "primitive.pd"

=head2 vsearch

=for sig

  Signature: ( vals(); xs(n); [o] indx(); [\%options] )

=for ref

Efficiently search for values in a sorted ndarray, returning indices.

=for usage

  $idx = vsearch( $vals, $x, [\%options] );
  vsearch( $vals, $x, $idx, [\%options ] );

B<vsearch> performs a binary search in the ordered ndarray C<$x>,
for the values from C<$vals> ndarray, returning indices into C<$x>.
What is a "match", and the meaning of the returned indices, are determined
by the options.

The C<mode> option indicates which method of searching to use, and may
be one of:

=over

=item C<sample>

invoke L<B<vsearch_sample>|/vsearch_sample>, returning indices appropriate for sampling
within a distribution.

=item C<insert_leftmost>

invoke L<B<vsearch_insert_leftmost>|/vsearch_insert_leftmost>, returning the left-most possible
insertion point which still leaves the ndarray sorted.

=item C<insert_rightmost>

invoke L<B<vsearch_insert_rightmost>|/vsearch_insert_rightmost>, returning the right-most possible
insertion point which still leaves the ndarray sorted.

=item C<match>

invoke L<B<vsearch_match>|/vsearch_match>, returning the index of a matching element,
else -(insertion point + 1)

=item C<bin_inclusive>

invoke L<B<vsearch_bin_inclusive>|/vsearch_bin_inclusive>, returning an index appropriate for binning
on a grid where the left bin edges are I<inclusive> of the bin. See
below for further explanation of the bin.

=item C<bin_exclusive>

invoke L<B<vsearch_bin_exclusive>|/vsearch_bin_exclusive>, returning an index appropriate for binning
on a grid where the left bin edges are I<exclusive> of the bin. See
below for further explanation of the bin.

=back

The default value of C<mode> is C<sample>.

=for example

  use PDL;
  
  my @modes = qw( sample insert_leftmost insert_rightmost match
                  bin_inclusive bin_exclusive );
  
  # Generate a sequence of 3 zeros, 3 ones, ..., 3 fours.
  my $x = zeroes(3,5)->yvals->flat;
  
  for my $mode ( @modes ) {
    # if the value is in $x
    my $contained = 2;
    my $idx_contained = vsearch( $contained, $x, { mode => $mode } );
    my $x_contained = $x->copy;
    $x_contained->slice( $idx_contained ) .= 9;
    
    # if the value is not in $x
    my $not_contained = 1.5;
    my $idx_not_contained = vsearch( $not_contained, $x, { mode => $mode } );
    my $x_not_contained = $x->copy;
    $x_not_contained->slice( $idx_not_contained ) .= 9;
    
    print sprintf("%-23s%30s\n", '$x', $x);
    print sprintf("%-23s%30s\n",   "$mode ($contained)", $x_contained);
    print sprintf("%-23s%30s\n\n", "$mode ($not_contained)", $x_not_contained);
  }
  
  # $x                     [0 0 0 1 1 1 2 2 2 3 3 3 4 4 4]
  # sample (2)             [0 0 0 1 1 1 9 2 2 3 3 3 4 4 4]
  # sample (1.5)           [0 0 0 1 1 1 9 2 2 3 3 3 4 4 4]
  # 
  # $x                     [0 0 0 1 1 1 2 2 2 3 3 3 4 4 4]
  # insert_leftmost (2)    [0 0 0 1 1 1 9 2 2 3 3 3 4 4 4]
  # insert_leftmost (1.5)  [0 0 0 1 1 1 9 2 2 3 3 3 4 4 4]
  # 
  # $x                     [0 0 0 1 1 1 2 2 2 3 3 3 4 4 4]
  # insert_rightmost (2)   [0 0 0 1 1 1 2 2 2 9 3 3 4 4 4]
  # insert_rightmost (1.5) [0 0 0 1 1 1 9 2 2 3 3 3 4 4 4]
  # 
  # $x                     [0 0 0 1 1 1 2 2 2 3 3 3 4 4 4]
  # match (2)              [0 0 0 1 1 1 2 9 2 3 3 3 4 4 4]
  # match (1.5)            [0 0 0 1 1 1 2 2 9 3 3 3 4 4 4]
  # 
  # $x                     [0 0 0 1 1 1 2 2 2 3 3 3 4 4 4]
  # bin_inclusive (2)      [0 0 0 1 1 1 2 2 9 3 3 3 4 4 4]
  # bin_inclusive (1.5)    [0 0 0 1 1 9 2 2 2 3 3 3 4 4 4]
  # 
  # $x                     [0 0 0 1 1 1 2 2 2 3 3 3 4 4 4]
  # bin_exclusive (2)      [0 0 0 1 1 9 2 2 2 3 3 3 4 4 4]
  # bin_exclusive (1.5)    [0 0 0 1 1 9 2 2 2 3 3 3 4 4 4]


Also see
L<B<vsearch_sample>|/vsearch_sample>,
L<B<vsearch_insert_leftmost>|/vsearch_insert_leftmost>,
L<B<vsearch_insert_rightmost>|/vsearch_insert_rightmost>,
L<B<vsearch_match>|/vsearch_match>,
L<B<vsearch_bin_inclusive>|/vsearch_bin_inclusive>, and
L<B<vsearch_bin_exclusive>|/vsearch_bin_exclusive>

=cut

sub vsearch {
    my $opt = 'HASH' eq ref $_[-1]
            ? pop
	    : { mode => 'sample' };

    croak( "unknown options to vsearch\n" )
	if ( ! defined $opt->{mode} && keys %$opt )
	|| keys %$opt > 1;

    my $mode = $opt->{mode};
    goto
        $mode eq 'sample'           ? \&vsearch_sample
      : $mode eq 'insert_leftmost'  ? \&vsearch_insert_leftmost
      : $mode eq 'insert_rightmost' ? \&vsearch_insert_rightmost
      : $mode eq 'match'            ? \&vsearch_match
      : $mode eq 'bin_inclusive'    ? \&vsearch_bin_inclusive
      : $mode eq 'bin_exclusive'    ? \&vsearch_bin_exclusive
      :                               croak( "unknown vsearch mode: $mode\n" );
}

*PDL::vsearch = \&vsearch;
#line 2691 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 vsearch_sample

=for sig

  Signature: (vals(); x(n); indx [o]idx())


=for ref

Search for values in a sorted array, return index appropriate for sampling from a distribution

=for usage

  $idx = vsearch_sample($vals, $x);

C<$x> must be sorted, but may be in decreasing or increasing
order.



B<vsearch_sample> returns an index I<I> for each value I<V> of C<$vals> appropriate
for sampling C<$vals>



                   

I<I> has the following properties:

=over

=item *

if C<$x> is sorted in increasing order


          V <= x[0]  : I = 0
  x[0]  < V <= x[-1] : I s.t. x[I-1] < V <= x[I]
  x[-1] < V          : I = $x->nelem -1



=item *

if C<$x> is sorted in decreasing order


           V > x[0]  : I = 0
  x[0]  >= V > x[-1] : I s.t. x[I] >= V > x[I+1]
  x[-1] >= V         : I = $x->nelem - 1



=back




If all elements of C<$x> are equal, I<< I = $x->nelem - 1 >>.

If C<$x> contains duplicated elements, I<I> is the index of the
leftmost (by position in array) duplicate if I<V> matches.

=for example

This function is useful e.g. when you have a list of probabilities
for events and want to generate indices to events:

 $x = pdl(.01,.86,.93,1); # Barnsley IFS probabilities cumulatively
 $y = random 20;
 $c = vsearch_sample($y, $x); # Now, $c will have the appropriate distr.

It is possible to use the L<cumusumover|PDL::Ufunc/cumusumover>
function to obtain cumulative probabilities from absolute probabilities.







=for bad

needs major (?) work to handles bad values

=cut
#line 2785 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*vsearch_sample = \&PDL::vsearch_sample;
#line 2792 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 vsearch_insert_leftmost

=for sig

  Signature: (vals(); x(n); indx [o]idx())


=for ref

Determine the insertion point for values in a sorted array, inserting before duplicates.

=for usage

  $idx = vsearch_insert_leftmost($vals, $x);

C<$x> must be sorted, but may be in decreasing or increasing
order.



B<vsearch_insert_leftmost> returns an index I<I> for each value I<V> of
C<$vals> equal to the leftmost position (by index in array) within
C<$x> that I<V> may be inserted and still maintain the order in
C<$x>.

Insertion at index I<I> involves shifting elements I<I> and higher of
C<$x> to the right by one and setting the now empty element at index
I<I> to I<V>.



                   

I<I> has the following properties:

=over

=item *

if C<$x> is sorted in increasing order


          V <= x[0]  : I = 0
  x[0]  < V <= x[-1] : I s.t. x[I-1] < V <= x[I]
  x[-1] < V          : I = $x->nelem



=item *

if C<$x> is sorted in decreasing order


           V >  x[0]  : I = -1
  x[0]  >= V >= x[-1] : I s.t. x[I] >= V > x[I+1]
  x[-1] >= V          : I = $x->nelem -1



=back




If all elements of C<$x> are equal,

    i = 0

If C<$x> contains duplicated elements, I<I> is the index of the
leftmost (by index in array) duplicate if I<V> matches.







=for bad

needs major (?) work to handles bad values

=cut
#line 2882 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*vsearch_insert_leftmost = \&PDL::vsearch_insert_leftmost;
#line 2889 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 vsearch_insert_rightmost

=for sig

  Signature: (vals(); x(n); indx [o]idx())


=for ref

Determine the insertion point for values in a sorted array, inserting after duplicates.

=for usage

  $idx = vsearch_insert_rightmost($vals, $x);

C<$x> must be sorted, but may be in decreasing or increasing
order.



B<vsearch_insert_rightmost> returns an index I<I> for each value I<V> of
C<$vals> equal to the rightmost position (by index in array) within
C<$x> that I<V> may be inserted and still maintain the order in
C<$x>.

Insertion at index I<I> involves shifting elements I<I> and higher of
C<$x> to the right by one and setting the now empty element at index
I<I> to I<V>.



                   

I<I> has the following properties:

=over

=item *

if C<$x> is sorted in increasing order


           V < x[0]  : I = 0
  x[0]  <= V < x[-1] : I s.t. x[I-1] <= V < x[I]
  x[-1] <= V         : I = $x->nelem



=item *

if C<$x> is sorted in decreasing order


          V >= x[0]  : I = -1
  x[0]  > V >= x[-1] : I s.t. x[I] >= V > x[I+1]
  x[-1] > V          : I = $x->nelem -1



=back




If all elements of C<$x> are equal,

    i = $x->nelem - 1

If C<$x> contains duplicated elements, I<I> is the index of the
leftmost (by index in array) duplicate if I<V> matches.







=for bad

needs major (?) work to handles bad values

=cut
#line 2979 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*vsearch_insert_rightmost = \&PDL::vsearch_insert_rightmost;
#line 2986 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 vsearch_match

=for sig

  Signature: (vals(); x(n); indx [o]idx())


=for ref

Match values against a sorted array.

=for usage

  $idx = vsearch_match($vals, $x);

C<$x> must be sorted, but may be in decreasing or increasing
order.



B<vsearch_match> returns an index I<I> for each value I<V> of
C<$vals>.  If I<V> matches an element in C<$x>, I<I> is the
index of that element, otherwise it is I<-( insertion_point + 1 )>,
where I<insertion_point> is an index in C<$x> where I<V> may be
inserted while maintaining the order in C<$x>.  If C<$x> has
duplicated values, I<I> may refer to any of them.



                   





=for bad

needs major (?) work to handles bad values

=cut
#line 3034 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*vsearch_match = \&PDL::vsearch_match;
#line 3041 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 vsearch_bin_inclusive

=for sig

  Signature: (vals(); x(n); indx [o]idx())


=for ref

Determine the index for values in a sorted array of bins, lower bound inclusive.

=for usage

  $idx = vsearch_bin_inclusive($vals, $x);

C<$x> must be sorted, but may be in decreasing or increasing
order.



C<$x> represents the edges of contiguous bins, with the first and
last elements representing the outer edges of the outer bins, and the
inner elements the shared bin edges.

The lower bound of a bin is inclusive to the bin, its outer bound is exclusive to it.
B<vsearch_bin_inclusive> returns an index I<I> for each value I<V> of C<$vals>



                   

I<I> has the following properties:

=over

=item *

if C<$x> is sorted in increasing order


           V < x[0]  : I = -1
  x[0]  <= V < x[-1] : I s.t. x[I] <= V < x[I+1]
  x[-1] <= V         : I = $x->nelem - 1



=item *

if C<$x> is sorted in decreasing order


           V >= x[0]  : I = 0
  x[0]  >  V >= x[-1] : I s.t. x[I+1] > V >= x[I]
  x[-1] >  V          : I = $x->nelem



=back




If all elements of C<$x> are equal,

    i = $x->nelem - 1

If C<$x> contains duplicated elements, I<I> is the index of the
righmost (by index in array) duplicate if I<V> matches.







=for bad

needs major (?) work to handles bad values

=cut
#line 3129 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*vsearch_bin_inclusive = \&PDL::vsearch_bin_inclusive;
#line 3136 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 vsearch_bin_exclusive

=for sig

  Signature: (vals(); x(n); indx [o]idx())


=for ref

Determine the index for values in a sorted array of bins, lower bound exclusive.

=for usage

  $idx = vsearch_bin_exclusive($vals, $x);

C<$x> must be sorted, but may be in decreasing or increasing
order.



C<$x> represents the edges of contiguous bins, with the first and
last elements representing the outer edges of the outer bins, and the
inner elements the shared bin edges.

The lower bound of a bin is exclusive to the bin, its upper bound is inclusive to it.
B<vsearch_bin_exclusive> returns an index I<I> for each value I<V> of C<$vals>.



                   

I<I> has the following properties:

=over

=item *

if C<$x> is sorted in increasing order


           V <= x[0]  : I = -1
  x[0]  <  V <= x[-1] : I s.t. x[I] < V <= x[I+1]
  x[-1] <  V          : I = $x->nelem - 1



=item *

if C<$x> is sorted in decreasing order


           V >  x[0]  : I = 0
  x[0]  >= V >  x[-1] : I s.t. x[I-1] >= V > x[I]
  x[-1] >= V          : I = $x->nelem



=back




If all elements of C<$x> are equal,

    i = $x->nelem - 1

If C<$x> contains duplicated elements, I<I> is the index of the
righmost (by index in array) duplicate if I<V> matches.







=for bad

needs major (?) work to handles bad values

=cut
#line 3224 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*vsearch_bin_exclusive = \&PDL::vsearch_bin_exclusive;
#line 3231 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 interpolate

=for sig

  Signature: (xi(); x(n); y(n); [o] yi(); int [o] err())


=for ref

routine for 1D linear interpolation

=for usage

 ( $yi, $err ) = interpolate($xi, $x, $y)

Given a set of points C<($x,$y)>, use linear interpolation
to find the values C<$yi> at a set of points C<$xi>.

C<interpolate> uses a binary search to find the suspects, er...,
interpolation indices and therefore abscissas (ie C<$x>)
have to be I<strictly> ordered (increasing or decreasing).
For interpolation at lots of
closely spaced abscissas an approach that uses the last index found as
a start for the next search can be faster (compare Numerical Recipes
C<hunt> routine). Feel free to implement that on top of the binary
search if you like. For out of bounds values it just does a linear
extrapolation and sets the corresponding element of C<$err> to 1,
which is otherwise 0.

See also L</interpol>, which uses the same routine,
differing only in the handling of extrapolation - an error message
is printed rather than returning an error ndarray.



=for bad

needs major (?) work to handles bad values

=cut
#line 3279 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*interpolate = \&PDL::interpolate;
#line 3286 "Primitive.pm"



#line 3034 "primitive.pd"

=head2 interpol

=for sig

 Signature: (xi(); x(n); y(n); [o] yi())

=for ref

routine for 1D linear interpolation

=for usage

 $yi = interpol($xi, $x, $y)

C<interpol> uses the same search method as L</interpolate>,
hence C<$x> must be I<strictly> ordered (either increasing or decreasing).
The difference occurs in the handling of out-of-bounds values; here
an error message is printed.

=cut

# kept in for backwards compatability
sub interpol ($$$;$) {
    my $xi = shift;
    my $x  = shift;
    my $y  = shift;
    my $yi = @_ == 1 ? $_[0] : PDL->null;
    interpolate( $xi, $x, $y, $yi, my $err = PDL->null );
    print "some values had to be extrapolated\n"
	if any $err;
    return $yi if @_ == 0;
} # sub: interpol()
*PDL::interpol = \&interpol;
#line 3325 "Primitive.pm"



#line 3072 "primitive.pd"

=head2 interpND

=for ref

Interpolate values from an N-D ndarray, with switchable method

=for example

  $source = 10*xvals(10,10) + yvals(10,10);
  $index = pdl([[2.2,3.5],[4.1,5.0]],[[6.0,7.4],[8,9]]);
  print $source->interpND( $index );

InterpND acts like L<indexND|PDL::Slices/indexND>,
collapsing C<$index> by lookup
into C<$source>; but it does interpolation rather than direct sampling.
The interpolation method and boundary condition are switchable via
an options hash.

By default, linear or sample interpolation is used, with constant
value outside the boundaries of the source pdl.  No dataflow occurs,
because in general the output is computed rather than indexed.

All the interpolation methods treat the pixels as value-centered, so
the C<sample> method will return C<< $a->(0) >> for coordinate values on
the set [-0.5,0.5), and all methods will return C<< $a->(1) >> for
a coordinate value of exactly 1.


Recognized options:

=over 3

=item method

Values can be:

=over 3

=item * 0, s, sample, Sample (default for integer source types)

The nearest value is taken. Pixels are regarded as centered on their
respective integer coordinates (no offset from the linear case).

=item * 1, l, linear, Linear (default for floating point source types)

The values are N-linearly interpolated from an N-dimensional cube of size 2.

=item * 3, c, cube, cubic, Cubic

The values are interpolated using a local cubic fit to the data.  The
fit is constrained to match the original data and its derivative at the
data points.  The second derivative of the fit is not continuous at the
data points.  Multidimensional datasets are interpolated by the
successive-collapse method.

(Note that the constraint on the first derivative causes a small amount
of ringing around sudden features such as step functions).

=item * f, fft, fourier, Fourier

The source is Fourier transformed, and the interpolated values are
explicitly calculated from the coefficients.  The boundary condition
option is ignored -- periodic boundaries are imposed.

If you pass in the option "fft", and it is a list (ARRAY) ref, then it
is a stash for the magnitude and phase of the source FFT.  If the list
has two elements then they are taken as already computed; otherwise
they are calculated and put in the stash.

=back

=item b, bound, boundary, Boundary

This option is passed unmodified into L<indexND|PDL::Slices/indexND>,
which is used as the indexing engine for the interpolation.
Some current allowed values are 'extend', 'periodic', 'truncate', and 'mirror'
(default is 'truncate').

=item bad

contains the fill value used for 'truncate' boundary.  (default 0)

=item fft

An array ref whose associated list is used to stash the FFT of the source
data, for the FFT method.

=back

=cut

*interpND = *PDL::interpND;
sub PDL::interpND {
  my $source = shift;
  my $index = shift;
  my $options = shift;

  barf 'Usage: interp_nd($source,$index,[{%options}])\n'
    if(defined $options   and    ref $options ne 'HASH');

  my($opt) = (defined $options) ? $options : {};

  my($method)   = $opt->{m} || $opt->{meth} || $opt->{method} || $opt->{Method};
  $method //= $source->type->integer ? 'sample' : 'linear';

  my($boundary) = $opt->{b} || $opt->{boundary} || $opt->{Boundary} || $opt->{bound} || $opt->{Bound} || 'extend';
  my($bad) = $opt->{bad} || $opt->{Bad} || 0.0;

  if($method =~ m/^s(am(p(le)?)?)?/i) {
    return $source->range(PDL::Math::floor($index+0.5),0,$boundary);
  }

  elsif (($method eq 1) || $method =~ m/^l(in(ear)?)?/i) {
    ## key: (ith = index broadcast; cth = cube broadcast; sth = source broadcast)
    my $d = $index->dim(0);
    my $di = $index->ndims - 1;

    # Grab a 2-on-a-side n-cube around each desired pixel
    my $samp = $source->range($index->floor,2,$boundary); # (ith, cth, sth)

    # Reorder to put the cube dimensions in front and convert to a list
    $samp = $samp->reorder( $di .. $di+$d-1,
			    0 .. $di-1,
			    $di+$d .. $samp->ndims-1) # (cth, ith, sth)
                  ->clump($d); # (clst, ith, sth)

    # Enumerate the corners of an n-cube and convert to a list
    # (the 'x' is the normal perl repeat operator)
    my $crnr = PDL::Basic::ndcoords( (2) x $index->dim(0) ) # (index,cth)
             ->mv(0,-1)->clump($index->dim(0))->mv(-1,0); # (index, clst)

    # a & b are the weighting coefficients.
    my($x,$y);
    my($indexwhere);
    ($indexwhere = $index->where( 0 * $index )) .= -10; # Change NaN to invalid
    {
      my $bb = PDL::Math::floor($index);
      $x = ($index - $bb)     -> dummy(1,$crnr->dim(1)); # index, clst, ith
      $y = ($bb + 1 - $index) -> dummy(1,$crnr->dim(1)); # index, clst, ith
    }

    # Use 1/0 corners to select which multiplier happens, multiply
    # 'em all together to get sample weights, and sum to get the answer.
    my $out0 =  ( ($x * ($crnr==1) + $y * ($crnr==0)) #index, clst, ith
		 -> prodover                          #clst, ith
		 );

    my $out = ($out0 * $samp)->sumover; # ith, sth

    # Work around BAD-not-being-contagious bug in PDL <= 2.6 bad handling code  --CED 3-April-2013
    if ($source->badflag) {
	my $baddies = $samp->isbad->orover;
	$out = $out->setbadif($baddies);
    }

    return $out;

  } elsif(($method eq 3) || $method =~ m/^c(u(b(e|ic)?)?)?/i) {

      my ($d,@di) = $index->dims;
      my $di = $index->ndims - 1;

      # Grab a 4-on-a-side n-cube around each desired pixel
      my $samp = $source->range($index->floor - 1,4,$boundary) #ith, cth, sth
	  ->reorder( $di .. $di+$d-1, 0..$di-1, $di+$d .. $source->ndims-1 );
	                   # (cth, ith, sth)

      # Make a cube of the subpixel offsets, and expand its dims to
      # a 4-on-a-side N-1 cube, to match the slices of $samp (used below).
      my $y = $index - $index->floor;
      for my $i(1..$d-1) {
	  $y = $y->dummy($i,4);
      }

      # Collapse by interpolation, one dimension at a time...
      for my $i(0..$d-1) {
	  my $a0 = $samp->slice("(1)");    # Just-under-sample
	  my $a1 = $samp->slice("(2)");    # Just-over-sample
	  my $a1a0 = $a1 - $a0;

	  my $gradient = 0.5 * ($samp->slice("2:3")-$samp->slice("0:1"));
	  my $s0 = $gradient->slice("(0)");   # Just-under-gradient
	  my $s1 = $gradient->slice("(1)");   # Just-over-gradient

	  my $bb = $y->slice("($i)");

	  # Collapse the sample...
	  $samp = ( $a0 +
		    $bb * (
			   $s0  +
			   $bb * ( (3 * $a1a0 - 2*$s0 - $s1) +
				   $bb * ( $s1 + $s0 - 2*$a1a0 )
				   )
			   )
		    );

	  # "Collapse" the subpixel offset...
	  $y = $y->slice(":,($i)");
      }

      return $samp;

  } elsif($method =~ m/^f(ft|ourier)?/i) {

     local $@;
     eval "use PDL::FFT;";
     my $fftref = $opt->{fft};
     $fftref = [] unless(ref $fftref eq 'ARRAY');
     if(@$fftref != 2) {
	 my $x = $source->copy;
	 my $y = zeroes($source);
	 fftnd($x,$y);
	 $fftref->[0] = sqrt($x*$x+$y*$y) / $x->nelem;
	 $fftref->[1] = - atan2($y,$x);
     }

     my $i;
     my $c = PDL::Basic::ndcoords($source);               # (dim, source-dims)
     for $i(1..$index->ndims-1) {
	 $c = $c->dummy($i,$index->dim($i))
     }
     my $id = $index->ndims-1;
     my $phase = (($c * $index * 3.14159 * 2 / pdl($source->dims))
		  ->sumover) # (index-dims, source-dims)
 	          ->reorder($id..$id+$source->ndims-1,0..$id-1); # (src, index)

     my $phref = $fftref->[1]->copy;        # (source-dims)
     my $mag = $fftref->[0]->copy;          # (source-dims)

     for $i(1..$index->ndims-1) {
	 $phref = $phref->dummy(-1,$index->dim($i));
	 $mag = $mag->dummy(-1,$index->dim($i));
     }
     my $out = cos($phase + $phref ) * $mag;
     $out = $out->clump($source->ndims)->sumover;

     return $out;
 }  else {
     barf("interpND: unknown method '$method'; valid ones are 'linear' and 'sample'.\n");
 }
}
#line 3572 "Primitive.pm"



#line 3322 "primitive.pd"

=head2 one2nd

=for ref

Converts a one dimensional index ndarray to a set of ND coordinates

=for usage

 @coords=one2nd($x, $indices)

returns an array of ndarrays containing the ND indexes corresponding to
the one dimensional list indices. The indices are assumed to
correspond to array C<$x> clumped using C<clump(-1)>. This routine is
used in the old vector form of L</whichND>, but is useful on
its own occasionally.

Returned ndarrays have the L<indx|PDL::Core/indx> datatype.  C<$indices> can have
values larger than C<< $x->nelem >> but negative values in C<$indices>
will not give the answer you expect.

=for example

 pdl> $x=pdl [[[1,2],[-1,1]], [[0,-3],[3,2]]]; $c=$x->clump(-1)
 pdl> $maxind=maximum_ind($c); p $maxind;
 6
 pdl> print one2nd($x, maximum_ind($c))
 0 1 1
 pdl> p $x->at(0,1,1)
 3

=cut

*one2nd = \&PDL::one2nd;
sub PDL::one2nd {
  barf "Usage: one2nd \$array \$indices\n" if @_ != 2;
  my ($x, $ind)=@_;
  my @dimension=$x->dims;
  $ind = indx($ind);
  my(@index);
  my $count=0;
  foreach (@dimension) {
    $index[$count++]=$ind % $_;
    $ind /= $_;
  }
  return @index;
}
#line 3624 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 which

=for sig

  Signature: (mask(n); indx [o] inds(n); indx [o]lastout())


=for ref

Returns indices of non-zero values from a 1-D PDL

=for usage

 $i = which($mask);

returns a pdl with indices for all those elements that are nonzero in
the mask. Note that the returned indices will be 1D. If you feed in a
multidimensional mask, it will be flattened before the indices are
calculated.  See also L</whichND> for multidimensional masks.

If you want to index into the original mask or a similar ndarray
with output from C<which>, remember to flatten it before calling index:

  $data = random 5, 5;
  $idx = which $data > 0.5; # $idx is now 1D
  $bigsum = $data->flat->index($idx)->sum;  # flatten before indexing

Compare also L</where> for similar functionality.

SEE ALSO:

L</which_both> returns separately the indices of both nonzero and zero
values in the mask.

L</where_both> returns separately slices of both nonzero and zero
values in the mask.

L</where> returns associated values from a data PDL, rather than
indices into the mask PDL.

L</whichND> returns N-D indices into a multidimensional PDL.

=for example

 pdl> $x = sequence(10); p $x
 [0 1 2 3 4 5 6 7 8 9]
 pdl> $indx = which($x>6); p $indx
 [7 8 9]



=for bad

which processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 3690 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

   sub which { my ($this,$out) = @_;
		$this = $this->flat;
		$out //= $this->nullcreate;
		PDL::_which_int($this,$out,my $lastout = $this->nullcreate);
		my $lastoutmax = $lastout->max->sclr;
		$lastoutmax ? $out->slice('0:'.($lastoutmax-1))->sever : empty(indx);
   }
   *PDL::which = \&which;
#line 3704 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*which = \&PDL::which;
#line 3711 "Primitive.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 which_both

=for sig

  Signature: (mask(n); indx [o] inds(n); indx [o]notinds(n); indx [o]lastout(); indx [o]lastoutn())


=for ref

Returns indices of nonzero and zero values in a mask PDL

=for usage

 ($i, $c_i) = which_both($mask);

This works just as L</which>, but the complement of C<$i> will be in
C<$c_i>.

=for example

 pdl> p $x = sequence(10)
 [0 1 2 3 4 5 6 7 8 9]
 pdl> ($big, $small) = which_both($x >= 5); p "$big\n$small"
 [5 6 7 8 9]
 [0 1 2 3 4]



=for bad

which_both processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 3754 "Primitive.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

   sub which_both { my ($this,$outi,$outni) = @_;
		$this = $this->flat;
		$outi //= $this->nullcreate;
		$outni //= $this->nullcreate;
		PDL::_which_both_int($this,$outi,$outni,my $lastout = $this->nullcreate,my $lastoutn = $this->nullcreate);
		my $lastoutmax = $lastout->max->sclr;
		$outi = $lastoutmax ? $outi->slice('0:'.($lastoutmax-1))->sever : empty(indx);
		return $outi if !wantarray;
		my $lastoutnmax = $lastoutn->max->sclr;
		($outi, $lastoutnmax ? $outni->slice('0:'.($lastoutnmax-1))->sever : empty(indx));
   }
   *PDL::which_both = \&which_both;
#line 3772 "Primitive.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*which_both = \&PDL::which_both;
#line 3779 "Primitive.pm"



#line 3503 "primitive.pd"

=head2 where

=for ref

Use a mask to select values from one or more data PDLs

C<where> accepts one or more data ndarrays and a mask ndarray.  It
returns a list of output ndarrays, corresponding to the input data
ndarrays.  Each output ndarray is a 1-dimensional list of values in its
corresponding data ndarray. The values are drawn from locations where
the mask is nonzero.

The output PDLs are still connected to the original data PDLs, for the
purpose of dataflow.

C<where> combines the functionality of L</which> and L<index|PDL::Slices/index>
into a single operation.

BUGS:

While C<where> works OK for most N-dimensional cases, it does not
broadcast properly over (for example) the (N+1)th dimension in data
that is compared to an N-dimensional mask.  Use C<whereND> for that.

=for usage

 $i = $x->where($x+5 > 0); # $i contains those elements of $x
                           # where mask ($x+5 > 0) is 1
 $i .= -5;  # Set those elements (of $x) to -5. Together, these
            # commands clamp $x to a maximum of -5.

It is also possible to use the same mask for several ndarrays with
the same call:

 ($i,$j,$k) = where($x,$y,$z, $x+5>0);

Note: C<$i> is always 1-D, even if C<$x> is E<gt>1-D.

WARNING: The first argument
(the values) and the second argument (the mask) currently have to have
the exact same dimensions (or horrible things happen). You *cannot*
broadcast over a smaller mask, for example.

=cut

sub PDL::where {
    barf "Usage: where( \$pdl1, ..., \$pdlN, \$mask )\n" if @_ == 1;
    if(@_ == 2) {
	my($data,$mask) = @_;
	$data = $_[0]->clump(-1) if $_[0]->getndims>1;
	$mask = $_[1]->clump(-1) if $_[0]->getndims>1;
	return $data->index($mask->which());
    } else {
	if($_[-1]->getndims > 1) {
	    my $mask = $_[-1]->clump(-1)->which;
	    return map {$_->clump(-1)->index($mask)} @_[0..$#_-1];
	} else {
	    my $mask = $_[-1]->which;
	    return map {$_->index($mask)} @_[0..$#_-1];
	}
    }
}
*where = \&PDL::where;
#line 3848 "Primitive.pm"



#line 3571 "primitive.pd"

=head2 where_both

=for ref

Returns slices (non-zero in mask, zero) of an ndarray according to a mask

=for usage

 ($match_vals, $non_match_vals) = where_both($pdl, $mask);

This works like L</which_both>, but (flattened) data-flowing slices
rather than index-sets are returned.

=for example

 pdl> p $x = sequence(10) + 2
 [2 3 4 5 6 7 8 9 10 11]
 pdl> ($big, $small) = where_both($x, $x > 5); p "$big\n$small"
 [6 7 8 9 10 11]
 [2 3 4 5]
 pdl> p $big += 2, $small -= 1
 [8 9 10 11 12 13] [1 2 3 4]
 pdl> p $x
 [1 2 3 4 8 9 10 11 12 13]

=cut

sub PDL::where_both {
  barf "Usage: where_both(\$pdl, \$mask)\n" if @_ != 2;
  my ($arr, $mask) = @_;  # $mask has 0==false, 1==true
  my $arr_flat = $arr->clump(-1);
  map $arr_flat->index1d($_), PDL::which_both($mask);
}
*where_both = \&PDL::where_both;
#line 3888 "Primitive.pm"



#line 3609 "primitive.pd"

=head2 whereND

=for ref

C<where> with support for ND masks and broadcasting

C<whereND> accepts one or more data ndarrays and a
mask ndarray.  It returns a list of output ndarrays,
corresponding to the input data ndarrays.  The values
are drawn from locations where the mask is nonzero.

C<whereND> differs from C<where> in that the mask
dimensionality is preserved which allows for
proper broadcasting of the selection operation over
higher dimensions.

As with C<where> the output PDLs are still connected
to the original data PDLs, for the purpose of dataflow.

=for usage

  $sdata = whereND $data, $mask
  ($s1, $s2, ..., $sn) = whereND $d1, $d2, ..., $dn, $mask

  where

    $data is M dimensional
    $mask is N < M dimensional
    dims($data) 1..N == dims($mask) 1..N
    with broadcasting over N+1 to M dimensions

=for example

  $data   = sequence(4,3,2);   # example data array
  $mask4  = (random(4)>0.5);   # example 1-D mask array, has $n4 true values
  $mask43 = (random(4,3)>0.5); # example 2-D mask array, has $n43 true values
  $sdat4  = whereND $data, $mask4;   # $sdat4 is a [$n4,3,2] pdl
  $sdat43 = whereND $data, $mask43;  # $sdat43 is a [$n43,2] pdl

Just as with C<where>, you can use the returned value in an
assignment. That means that both of these examples are valid:

  # Used to create a new slice stored in $sdat4:
  $sdat4 = $data->whereND($mask4);
  $sdat4 .= 0;
  # Used in lvalue context:
  $data->whereND($mask4) .= 0;

SEE ALSO:

L</whichND> returns N-D indices into a multidimensional PDL, from a mask.

=cut

sub PDL::whereND :lvalue {
   barf "Usage: whereND( \$pdl1, ..., \$pdlN, \$mask )\n" if @_ == 1;
   my $mask = pop @_;  # $mask has 0==false, 1==true
   my @to_return;
   my $n = PDL::sum($mask);
   foreach my $arr (@_) {
      my $sub_i = $mask * ones($arr);
      my $where_sub_i = PDL::where($arr, $sub_i);
      # count the number of dims in $mask and $arr
      # $mask = a b c d e f.....
      my @idims = dims($arr);
      # ...and pop off the number of dims in $mask
      foreach ( dims($mask) ) { shift(@idims) };
      my $ndim = 0;
      foreach my $id ($n, @idims[0..($#idims-1)]) {
         $where_sub_i = $where_sub_i->splitdim($ndim++,$id) if $n>0;
      }
      push @to_return, $where_sub_i;
   }
   return (@to_return == 1) ? $to_return[0] : @to_return;
}
*whereND = \&PDL::whereND;
#line 3970 "Primitive.pm"



#line 3690 "primitive.pd"

=head2 whichND

=for ref

Return the coordinates of non-zero values in a mask.

=for usage

WhichND returns the N-dimensional coordinates of each nonzero value in
a mask PDL with any number of dimensions.  The returned values arrive
as an array-of-vectors suitable for use in
L<indexND|PDL::Slices/indexND> or L<range|PDL::Slices/range>.

 $coords = whichND($mask);

returns a PDL containing the coordinates of the elements that are non-zero
in C<$mask>, suitable for use in L<PDL::Slices/indexND>. The 0th dimension contains the
full coordinate listing of each point; the 1st dimension lists all the points.
For example, if $mask has rank 4 and 100 matching elements, then $coords has
dimension 4x100.

If no such elements exist, then whichND returns a structured empty PDL:
an Nx0 PDL that contains no values (but matches, broadcasting-wise, with
the vectors that would be produced if such elements existed).

DEPRECATED BEHAVIOR IN LIST CONTEXT:

whichND once delivered different values in list context than in scalar
context, for historical reasons.  In list context, it returned the
coordinates transposed, as a collection of 1-PDLs (one per dimension)
in a list.  This usage is deprecated in PDL 2.4.10, and will cause a
warning to be issued every time it is encountered.  To avoid the
warning, you can set the global variable "$PDL::whichND" to 's' to
get scalar behavior in all contexts, or to 'l' to get list behavior in
list context.

In later versions of PDL, the deprecated behavior will disappear.  Deprecated
list context whichND expressions can be replaced with:

    @list = $x->whichND->mv(0,-1)->dog;

SEE ALSO:

L</which> finds coordinates of nonzero values in a 1-D mask.

L</where> extracts values from a data PDL that are associated
with nonzero values in a mask PDL.

L<PDL::Slices/indexND> can be fed the coordinates to return the values.

=for example

 pdl> $s=sequence(10,10,3,4)
 pdl> ($x, $y, $z, $w)=whichND($s == 203); p $x, $y, $z, $w
 [3] [0] [2] [0]
 pdl> print $s->at(list(cat($x,$y,$z,$w)))
 203

=cut

*whichND = \&PDL::whichND;
sub PDL::whichND {
  my $mask = PDL->topdl(shift);

  # List context: generate a perl list by dimension
  if(wantarray) {
      if(!defined($PDL::whichND)) {
	  printf STDERR "whichND: WARNING - list context deprecated. Set \$PDL::whichND. Details in pod.";
      } elsif($PDL::whichND =~ m/l/i) {
	  # old list context enabled by setting $PDL::whichND to 'l'
	  my $ind=($mask->clump(-1))->which;
	  return $mask->one2nd($ind);
      }
      # if $PDL::whichND does not contain 'l' or 'L', fall through to scalar context
  }

  # Scalar context: generate an N-D index ndarray
  return PDL->new_from_specification(indx,$mask->ndims,0) if !$mask->nelem;
  return $mask ? pdl(indx,0) : PDL->new_from_specification(indx,0)
    if !$mask->getndims;

  my $ind = $mask->flat->which->dummy(0,$mask->getndims)->make_physical;
  # In the empty case, explicitly return the correct type of structured empty
  return PDL->new_from_specification(indx,$mask->ndims, 0) if !$ind->nelem;

  my $mult = ones(indx, $mask->getndims);
  my @mdims = $mask->dims;

  for my $i (0..$#mdims-1) {
   # use $tmp for 5.005_03 compatibility
   (my $tmp = $mult->index($i+1)) .= $mult->index($i)*$mdims[$i];
  }

  for my $i (0..$#mdims) {
   my($s) = $ind->index($i);
   $s /= $mult->index($i);
   $s %= $mdims[$i];
  }

  return $ind;
}
#line 4077 "Primitive.pm"



#line 3799 "primitive.pd"

=head2 setops

=for ref

Implements simple set operations like union and intersection

=for usage

   Usage: $set = setops($x, <OPERATOR>, $y);

The operator can be C<OR>, C<XOR> or C<AND>. This is then applied
to C<$x> viewed as a set and C<$y> viewed as a set. Set theory says
that a set may not have two or more identical elements, but setops
takes care of this for you, so C<$x=pdl(1,1,2)> is OK. The functioning
is as follows:

=over

=item C<OR>

The resulting vector will contain the elements that are either in C<$x>
I<or> in C<$y> or both. This is the union in set operation terms

=item C<XOR>

The resulting vector will contain the elements that are either in C<$x>
or C<$y>, but not in both. This is

     Union($x, $y) - Intersection($x, $y)

in set operation terms.

=item C<AND>

The resulting vector will contain the intersection of C<$x> and C<$y>, so
the elements that are in both C<$x> and C<$y>. Note that for convenience
this operation is also aliased to L</intersect>.

=back

It should be emphasized that these routines are used when one or both of
the sets C<$x>, C<$y> are hard to calculate or that you get from a separate
subroutine.

Finally IDL users might be familiar with Craig Markwardt's C<cmset_op.pro>
routine which has inspired this routine although it was written independently
However the present routine has a few less options (but see the examples)

=for example

You will very often use these functions on an index vector, so that is
what we will show here. We will in fact something slightly silly. First
we will find all squares that are also cubes below 10000.

Create a sequence vector:

  pdl> $x = sequence(10000)

Find all odd and even elements:

  pdl> ($even, $odd) = which_both( ($x % 2) == 0)

Find all squares

  pdl> $squares= which(ceil(sqrt($x)) == floor(sqrt($x)))

Find all cubes (being careful with roundoff error!)

  pdl> $cubes= which(ceil($x**(1.0/3.0)) == floor($x**(1.0/3.0)+1e-6))

Then find all squares that are cubes:

  pdl> $both = setops($squares, 'AND', $cubes)

And print these (assumes that C<PDL::NiceSlice> is loaded!)

  pdl> p $x($both)
   [0 1 64 729 4096]

Then find all numbers that are either cubes or squares, but not both:

  pdl> $cube_xor_square = setops($squares, 'XOR', $cubes)

  pdl> p $cube_xor_square->nelem()
   112

So there are a total of 112 of these!

Finally find all odd squares:

  pdl> $odd_squares = setops($squares, 'AND', $odd)


Another common occurrence is to want to get all objects that are
in C<$x> and in the complement of C<$y>. But it is almost always best
to create the complement explicitly since the universe that both are
taken from is not known. Thus use L</which_both> if possible
to keep track of complements.

If this is impossible the best approach is to make a temporary:

This creates an index vector the size of the universe of the sets and
set all elements in C<$y> to 0

  pdl> $tmp = ones($n_universe); $tmp($y) .= 0;

This then finds the complement of C<$y>

  pdl> $C_b = which($tmp == 1);

and this does the final selection:

  pdl> $set = setops($x, 'AND', $C_b)

=cut

*setops = \&PDL::setops;

sub PDL::setops {

  my ($x, $op, $y)=@_;

  # Check that $x and $y are 1D.
  if ($x->ndims() > 1 || $y->ndims() > 1) {
     warn 'setops: $x and $y must be 1D - flattening them!'."\n";
     $x = $x->flat;
     $y = $y->flat;
  }

  #Make sure there are no duplicate elements.
  $x=$x->uniq;
  $y=$y->uniq;

  my $result;

  if ($op eq 'OR') {
    # Easy...
    $result = uniq(append($x, $y));
  } elsif ($op eq 'XOR') {
    # Make ordered list of set union.
    my $union = append($x, $y)->qsort;
    # Index lists.
    my $s1=zeroes(byte, $union->nelem());
    my $s2=zeroes(byte, $union->nelem());

    # Find indices which are duplicated - these are to be excluded
    #
    # We do this by comparing x with x shifted each way.
    my $i1 = which($union != rotate($union, 1));
    my $i2 = which($union != rotate($union, -1));
    #
    # We then mark/mask these in the s1 and s2 arrays to indicate which ones
    # are not equal to their neighbours.
    #
    my $ts;
    ($ts = $s1->index($i1)) .= 1 if $i1->nelem() > 0;
    ($ts = $s2->index($i2)) .= 1 if $i2->nelem() > 0;

    my $inds=which($s1 == $s2);

    if ($inds->nelem() > 0) {
      return $union->index($inds);
    } else {
      return $inds;
    }

  } elsif ($op eq 'AND') {
    # The intersection of the arrays.

    # Make ordered list of set union.
    my $union = append($x, $y)->qsort;

    return $union->where($union == rotate($union, -1));
  } else {
    print "The operation $op is not known!";
    return -1;
  }

}
#line 4262 "Primitive.pm"



#line 3982 "primitive.pd"

=head2 intersect

=for ref

Calculate the intersection of two ndarrays

=for usage

   Usage: $set = intersect($x, $y);

This routine is merely a simple interface to L</setops>. See
that for more information

=for example

Find all numbers less that 100 that are of the form 2*y and 3*x

 pdl> $x=sequence(100)
 pdl> $factor2 = which( ($x % 2) == 0)
 pdl> $factor3 = which( ($x % 3) == 0)
 pdl> $ii=intersect($factor2, $factor3)
 pdl> p $x($ii)
 [0 6 12 18 24 30 36 42 48 54 60 66 72 78 84 90 96]

=cut

*intersect = \&PDL::intersect;

sub PDL::intersect {

   return setops($_[0], 'AND', $_[1]);

}
#line 4301 "Primitive.pm"





#line 4018 "primitive.pd"


=head1 AUTHOR

Copyright (C) Tuomas J. Lukka 1997 (lukka@husc.harvard.edu). Contributions
by Christian Soeller (c.soeller@auckland.ac.nz), Karl Glazebrook
(kgb@aaoepp.aao.gov.au), Craig DeForest (deforest@boulder.swri.edu)
and Jarle Brinchmann (jarle@astro.up.pt)
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.

Updated for CPAN viewing compatibility by David Mertens.

=cut
#line 4325 "Primitive.pm"




# Exit with OK status

1;