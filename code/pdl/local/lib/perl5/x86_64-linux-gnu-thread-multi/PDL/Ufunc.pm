#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Ufunc;

our @EXPORT_OK = qw(prodover cprodover dprodover cumuprodover dcumuprodover sumover csumover dsumover cumusumover dcumusumover andover bandover borover orover zcover intover average avgover caverage cavgover daverage davgover minimum minover minimum_ind minover_ind minimum_n_ind minover_n_ind maximum maxover maximum_ind maxover_ind maximum_n_ind maxover_n_ind minmaximum minmaxover avg sum prod davg dsum dprod zcheck and band or bor min max median mode oddmedian any all minmax medover oddmedover modeover pctover oddpctover pct oddpct qsort qsorti qsortvec qsortveci );
our %EXPORT_TAGS = (Func=>\@EXPORT_OK);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;


   
   our @ISA = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Ufunc ;






#line 9 "ufunc.pd"

use strict;
use warnings;

=head1 NAME

PDL::Ufunc - primitive ufunc operations for pdl

=head1 DESCRIPTION

This module provides some primitive and useful functions defined
using PDL::PP based on functionality of what are sometimes called
I<ufuncs> (for example NumPY and Mathematica talk about these).
It collects all the functions generally used to C<reduce> or
C<accumulate> along a dimension. These all do their job across the
first dimension but by using the slicing functions you can do it
on any dimension.

The L<PDL::Reduce> module provides an alternative interface
to many of the functions in this module.

=head1 SYNOPSIS

 use PDL::Ufunc;

=cut

use PDL::Slices;
use Carp;
#line 55 "Ufunc.pm"






=head1 FUNCTIONS

=cut




#line 948 "../../blib/lib/PDL/PP.pm"



=head2 prodover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via product to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the product along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = prodover($x);

=for example

 $spectrum = prodover $image->transpose





=for bad

prodover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 109 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*prodover = \&PDL::prodover;
#line 116 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 cprodover

=for sig

  Signature: (a(n); cdouble [o]b())


=for ref

Project via product to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the product along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = cprodover($x);

=for example

 $spectrum = cprodover $image->transpose

Unlike L</prodover>, the calculations are performed in complex double
precision.



=for bad

cprodover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 161 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*cprodover = \&PDL::cprodover;
#line 168 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 dprodover

=for sig

  Signature: (a(n); double [o]b())


=for ref

Project via product to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the product along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = dprodover($x);

=for example

 $spectrum = dprodover $image->transpose

Unlike L</prodover>, the calculations are performed in double precision.



=for bad

dprodover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 212 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*dprodover = \&PDL::dprodover;
#line 219 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 cumuprodover

=for sig

  Signature: (a(n); int+ [o]b(n))


=for ref

Cumulative product

This function calculates the cumulative product
along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

The sum is started so that the first element in the cumulative product
is the first element of the parameter.

=for usage

 $y = cumuprodover($x);

=for example

 $spectrum = cumuprodover $image->transpose





=for bad

cumuprodover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 266 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*cumuprodover = \&PDL::cumuprodover;
#line 273 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 dcumuprodover

=for sig

  Signature: (a(n); double [o]b(n))


=for ref

Cumulative product

This function calculates the cumulative product
along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

The sum is started so that the first element in the cumulative product
is the first element of the parameter.

=for usage

 $y = dcumuprodover($x);

=for example

 $spectrum = dcumuprodover $image->transpose

Unlike L</cumuprodover>, the calculations are performed in double precision.



=for bad

dcumuprodover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 320 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*dcumuprodover = \&PDL::dcumuprodover;
#line 327 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 sumover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via sum to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the sum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = sumover($x);

=for example

 $spectrum = sumover $image->transpose





=for bad

sumover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 371 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*sumover = \&PDL::sumover;
#line 378 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 csumover

=for sig

  Signature: (a(n); cdouble [o]b())


=for ref

Project via sum to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the sum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = csumover($x);

=for example

 $spectrum = csumover $image->transpose

Unlike L</sumover>, the calculations are performed in complex double
precision.



=for bad

csumover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 423 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*csumover = \&PDL::csumover;
#line 430 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 dsumover

=for sig

  Signature: (a(n); double [o]b())


=for ref

Project via sum to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the sum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = dsumover($x);

=for example

 $spectrum = dsumover $image->transpose

Unlike L</sumover>, the calculations are performed in double precision.



=for bad

dsumover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 474 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*dsumover = \&PDL::dsumover;
#line 481 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 cumusumover

=for sig

  Signature: (a(n); int+ [o]b(n))


=for ref

Cumulative sum

This function calculates the cumulative sum
along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

The sum is started so that the first element in the cumulative sum
is the first element of the parameter.

=for usage

 $y = cumusumover($x);

=for example

 $spectrum = cumusumover $image->transpose





=for bad

cumusumover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 528 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*cumusumover = \&PDL::cumusumover;
#line 535 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 dcumusumover

=for sig

  Signature: (a(n); double [o]b(n))


=for ref

Cumulative sum

This function calculates the cumulative sum
along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

The sum is started so that the first element in the cumulative sum
is the first element of the parameter.

=for usage

 $y = dcumusumover($x);

=for example

 $spectrum = dcumusumover $image->transpose

Unlike L</cumusumover>, the calculations are performed in double precision.



=for bad

dcumusumover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 582 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*dcumusumover = \&PDL::dcumusumover;
#line 589 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 andover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via and to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the and along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = andover($x);

=for example

 $spectrum = andover $image->transpose





=for bad

If C<a()> contains only bad data (and its bad flag is set), 
C<b()> is set bad. Otherwise C<b()> will have its bad flag cleared,
as it will not contain any bad values.

=cut
#line 633 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*andover = \&PDL::andover;
#line 640 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 bandover

=for sig

  Signature: (a(n);  [o]b())


=for ref

Project via bitwise and to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the bitwise and along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = bandover($x);

=for example

 $spectrum = bandover $image->transpose





=for bad

If C<a()> contains only bad data (and its bad flag is set), 
C<b()> is set bad. Otherwise C<b()> will have its bad flag cleared,
as it will not contain any bad values.

=cut
#line 684 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*bandover = \&PDL::bandover;
#line 691 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 borover

=for sig

  Signature: (a(n);  [o]b())


=for ref

Project via bitwise or to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the bitwise or along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = borover($x);

=for example

 $spectrum = borover $image->transpose





=for bad

If C<a()> contains only bad data (and its bad flag is set), 
C<b()> is set bad. Otherwise C<b()> will have its bad flag cleared,
as it will not contain any bad values.

=cut
#line 735 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*borover = \&PDL::borover;
#line 742 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 orover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via or to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the or along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = orover($x);

=for example

 $spectrum = orover $image->transpose





=for bad

If C<a()> contains only bad data (and its bad flag is set), 
C<b()> is set bad. Otherwise C<b()> will have its bad flag cleared,
as it will not contain any bad values.

=cut
#line 786 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*orover = \&PDL::orover;
#line 793 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 zcover

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via == 0 to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the == 0 along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = zcover($x);

=for example

 $spectrum = zcover $image->transpose





=for bad

If C<a()> contains only bad data (and its bad flag is set), 
C<b()> is set bad. Otherwise C<b()> will have its bad flag cleared,
as it will not contain any bad values.

=cut
#line 837 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*zcover = \&PDL::zcover;
#line 844 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 intover

=for sig

  Signature: (a(n); float+ [o]b())


=for ref

Project via integral to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the integral along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = intover($x);

=for example

 $spectrum = intover $image->transpose

Notes:

C<intover> uses a point spacing of one (i.e., delta-h==1).  You will
need to scale the result to correct for the true point delta).

For C<n E<gt> 3>, these are all C<O(h^4)> (like Simpson's rule), but are
integrals between the end points assuming the pdl gives values just at
these centres: for such `functions', sumover is correct to C<O(h)>, but
is the natural (and correct) choice for binned data, of course.




=for bad

intover ignores the bad-value flag of the input ndarrays.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 897 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*intover = \&PDL::intover;
#line 904 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 average

=for sig

  Signature: (a(n); int+ [o]b())


=for ref

Project via average to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the average along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = average($x);

=for example

 $spectrum = average $image->transpose





=for bad

average processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 948 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*average = \&PDL::average;
#line 955 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 avgover

=for ref

  Synonym for average.

=cut

*PDL::avgover = *avgover = \&PDL::average;
#line 970 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 caverage

=for sig

  Signature: (a(n); cdouble [o]b())


=for ref

Project via average to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the average along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = caverage($x);

=for example

 $spectrum = caverage $image->transpose

Unlike L<average|/average>, the calculation is performed in complex double
precision.



=for bad

caverage processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1015 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*caverage = \&PDL::caverage;
#line 1022 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 cavgover

=for ref

  Synonym for caverage.

=cut

*PDL::cavgover = *cavgover = \&PDL::caverage;
#line 1037 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 daverage

=for sig

  Signature: (a(n); double [o]b())


=for ref

Project via average to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the average along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = daverage($x);

=for example

 $spectrum = daverage $image->transpose

Unlike L<average|/average>, the calculation is performed in double
precision.



=for bad

daverage processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 1082 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*daverage = \&PDL::daverage;
#line 1089 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 davgover

=for ref

  Synonym for daverage.

=cut

*PDL::davgover = *davgover = \&PDL::daverage;
#line 1104 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 minimum

=for sig

  Signature: (a(n); [o]c())


=for ref

Project via minimum to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the minimum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = minimum($x);

=for example

 $spectrum = minimum $image->transpose





=for bad

Output is set bad if no elements of the input are non-bad,
otherwise the bad flag is cleared for the output ndarray.

Note that C<NaNs> are considered to be valid values and will "win" over non-C<NaN>;
see L<isfinite|PDL::Math/isfinite> and L<badmask|PDL::Bad/badmask>
for ways of masking NaNs.


=cut
#line 1152 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*minimum = \&PDL::minimum;
#line 1159 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 minover

=for ref

  Synonym for minimum.

=cut

*PDL::minover = *minover = \&PDL::minimum;
#line 1174 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 minimum_ind

=for sig

  Signature: (a(n); indx [o] c())

=for ref

Like minimum but returns the index rather than the value

=for bad

Output is set bad if no elements of the input are non-bad,
otherwise the bad flag is cleared for the output ndarray.

Note that C<NaNs> are considered to be valid values and will "win" over non-C<NaN>;
see L<isfinite|PDL::Math/isfinite> and L<badmask|PDL::Bad/badmask>
for ways of masking NaNs.


=cut
#line 1203 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*minimum_ind = \&PDL::minimum_ind;
#line 1210 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 minover_ind

=for ref

  Synonym for minimum_ind.

=cut

*PDL::minover_ind = *minover_ind = \&PDL::minimum_ind;
#line 1225 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 minimum_n_ind

=for sig

  Signature: (a(n); indx [o]c(m); PDL_Indx m_size => m)

=for ref

Returns the index of C<m_size> minimum elements. As of 2.077, you can
specify how many by either passing in an ndarray of the given size
(DEPRECATED - will be converted to indx if needed and the input arg will
be set to that), or just the size, or a null and the size.

=for usage

  minimum_n_ind($pdl, $out = zeroes(5)); # DEPRECATED
  $out = minimum_n_ind($pdl, 5);
  minimum_n_ind($pdl, $out = null, 5);



=for bad

Output bad flag is cleared for the output ndarray if sufficient non-bad elements found,
else remaining slots in C<$c()> are set bad.

Note that C<NaNs> are considered to be valid values and will "win" over non-C<NaN>;
see L<isfinite|PDL::Math/isfinite> and L<badmask|PDL::Bad/badmask>
for ways of masking NaNs.


=cut
#line 1265 "Ufunc.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


#line 409 "ufunc.pd"
sub PDL::minimum_n_ind {
  my ($a, $c, $m_size) = @_;
  $m_size //= ref($c) ? $c->dim(0) : $c; # back-compat with pre-2.077
  my $set_out = 1;
  $set_out = 0, $c = null if !ref $c;
  $c = $c->indx if !$c->isnull;
  PDL::_minimum_n_ind_int($a, $c, $m_size);
  $set_out ? $_[1] = $c : $c;
}
#line 961 "../../blib/lib/PDL/PP.pm"
#line 1283 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*minimum_n_ind = \&PDL::minimum_n_ind;
#line 1290 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 minover_n_ind

=for ref

  Synonym for minimum_n_ind.

=cut

*PDL::minover_n_ind = *minover_n_ind = \&PDL::minimum_n_ind;
#line 1305 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 maximum

=for sig

  Signature: (a(n); [o]c())


=for ref

Project via maximum to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the maximum along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = maximum($x);

=for example

 $spectrum = maximum $image->transpose





=for bad

Output is set bad if no elements of the input are non-bad,
otherwise the bad flag is cleared for the output ndarray.

Note that C<NaNs> are considered to be valid values and will "win" over non-C<NaN>;
see L<isfinite|PDL::Math/isfinite> and L<badmask|PDL::Bad/badmask>
for ways of masking NaNs.


=cut
#line 1353 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*maximum = \&PDL::maximum;
#line 1360 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 maxover

=for ref

  Synonym for maximum.

=cut

*PDL::maxover = *maxover = \&PDL::maximum;
#line 1375 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 maximum_ind

=for sig

  Signature: (a(n); indx [o] c())

=for ref

Like maximum but returns the index rather than the value

=for bad

Output is set bad if no elements of the input are non-bad,
otherwise the bad flag is cleared for the output ndarray.

Note that C<NaNs> are considered to be valid values and will "win" over non-C<NaN>;
see L<isfinite|PDL::Math/isfinite> and L<badmask|PDL::Bad/badmask>
for ways of masking NaNs.


=cut
#line 1404 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*maximum_ind = \&PDL::maximum_ind;
#line 1411 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 maxover_ind

=for ref

  Synonym for maximum_ind.

=cut

*PDL::maxover_ind = *maxover_ind = \&PDL::maximum_ind;
#line 1426 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 maximum_n_ind

=for sig

  Signature: (a(n); indx [o]c(m); PDL_Indx m_size => m)

=for ref

Returns the index of C<m_size> maximum elements. As of 2.077, you can
specify how many by either passing in an ndarray of the given size
(DEPRECATED - will be converted to indx if needed and the input arg will
be set to that), or just the size, or a null and the size.

=for usage

  maximum_n_ind($pdl, $out = zeroes(5)); # DEPRECATED
  $out = maximum_n_ind($pdl, 5);
  maximum_n_ind($pdl, $out = null, 5);



=for bad

Output bad flag is cleared for the output ndarray if sufficient non-bad elements found,
else remaining slots in C<$c()> are set bad.

Note that C<NaNs> are considered to be valid values and will "win" over non-C<NaN>;
see L<isfinite|PDL::Math/isfinite> and L<badmask|PDL::Bad/badmask>
for ways of masking NaNs.


=cut
#line 1466 "Ufunc.pm"



#line 949 "../../blib/lib/PDL/PP.pm"


#line 409 "ufunc.pd"
sub PDL::maximum_n_ind {
  my ($a, $c, $m_size) = @_;
  $m_size //= ref($c) ? $c->dim(0) : $c; # back-compat with pre-2.077
  my $set_out = 1;
  $set_out = 0, $c = null if !ref $c;
  $c = $c->indx if !$c->isnull;
  PDL::_maximum_n_ind_int($a, $c, $m_size);
  $set_out ? $_[1] = $c : $c;
}
#line 961 "../../blib/lib/PDL/PP.pm"
#line 1484 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*maximum_n_ind = \&PDL::maximum_n_ind;
#line 1491 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 maxover_n_ind

=for ref

  Synonym for maximum_n_ind.

=cut

*PDL::maxover_n_ind = *maxover_n_ind = \&PDL::maximum_n_ind;
#line 1506 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 minmaximum

=for sig

  Signature: (a(n); [o]cmin(); [o] cmax(); indx [o]cmin_ind(); indx [o]cmax_ind())


=for ref

Find minimum and maximum and their indices for a given ndarray;

=for usage

 pdl> $x=pdl [[-2,3,4],[1,0,3]]
 pdl> ($min, $max, $min_ind, $max_ind)=minmaximum($x)
 pdl> p $min, $max, $min_ind, $max_ind
 [-2 0] [4 3] [0 1] [2 2]

See also L</minmax>, which clumps the ndarray together.



=for bad

If C<a()> contains only bad data, then the output ndarrays will
be set bad, along with their bad flag.
Otherwise they will have their bad flags cleared,
since they will not contain any bad values.

=cut
#line 1544 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*minmaximum = \&PDL::minmaximum;
#line 1551 "Ufunc.pm"



#line 304 "ufunc.pd"

=head2 minmaxover

=for ref

  Synonym for minmaximum.

=cut

*PDL::minmaxover = *minmaxover = \&PDL::minmaximum;
#line 1566 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 avg

=for ref

Return the average of all elements in an ndarray.

See the documentation for L</average> for more information.

=for usage

 $x = avg($data);

=for bad

This routine handles bad values.

=cut

*avg = \&PDL::avg;
sub PDL::avg {
	my($x) = @_; my $tmp;
	$x->clump(-1)->average( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1596 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 sum

=for ref

Return the sum of all elements in an ndarray.

See the documentation for L</sumover> for more information.

=for usage

 $x = sum($data);

=for bad

This routine handles bad values.

=cut

*sum = \&PDL::sum;
sub PDL::sum {
	my($x) = @_; my $tmp;
	$x->clump(-1)->sumover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1626 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 prod

=for ref

Return the product of all elements in an ndarray.

See the documentation for L</prodover> for more information.

=for usage

 $x = prod($data);

=for bad

This routine handles bad values.

=cut

*prod = \&PDL::prod;
sub PDL::prod {
	my($x) = @_; my $tmp;
	$x->clump(-1)->prodover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1656 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 davg

=for ref

Return the average (in double precision) of all elements in an ndarray.

See the documentation for L</daverage> for more information.

=for usage

 $x = davg($data);

=for bad

This routine handles bad values.

=cut

*davg = \&PDL::davg;
sub PDL::davg {
	my($x) = @_; my $tmp;
	$x->clump(-1)->daverage( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1686 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 dsum

=for ref

Return the sum (in double precision) of all elements in an ndarray.

See the documentation for L</dsumover> for more information.

=for usage

 $x = dsum($data);

=for bad

This routine handles bad values.

=cut

*dsum = \&PDL::dsum;
sub PDL::dsum {
	my($x) = @_; my $tmp;
	$x->clump(-1)->dsumover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1716 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 dprod

=for ref

Return the product (in double precision) of all elements in an ndarray.

See the documentation for L</dprodover> for more information.

=for usage

 $x = dprod($data);

=for bad

This routine handles bad values.

=cut

*dprod = \&PDL::dprod;
sub PDL::dprod {
	my($x) = @_; my $tmp;
	$x->clump(-1)->dprodover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1746 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 zcheck

=for ref

Return the check for zero of all elements in an ndarray.

See the documentation for L</zcover> for more information.

=for usage

 $x = zcheck($data);

=for bad

This routine handles bad values.

=cut

*zcheck = \&PDL::zcheck;
sub PDL::zcheck {
	my($x) = @_; my $tmp;
	$x->clump(-1)->zcover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1776 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 and

=for ref

Return the logical and of all elements in an ndarray.

See the documentation for L</andover> for more information.

=for usage

 $x = and($data);

=for bad

This routine handles bad values.

=cut

*and = \&PDL::and;
sub PDL::and {
	my($x) = @_; my $tmp;
	$x->clump(-1)->andover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1806 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 band

=for ref

Return the bitwise and of all elements in an ndarray.

See the documentation for L</bandover> for more information.

=for usage

 $x = band($data);

=for bad

This routine handles bad values.

=cut

*band = \&PDL::band;
sub PDL::band {
	my($x) = @_; my $tmp;
	$x->clump(-1)->bandover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1836 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 or

=for ref

Return the logical or of all elements in an ndarray.

See the documentation for L</orover> for more information.

=for usage

 $x = or($data);

=for bad

This routine handles bad values.

=cut

*or = \&PDL::or;
sub PDL::or {
	my($x) = @_; my $tmp;
	$x->clump(-1)->orover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1866 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 bor

=for ref

Return the bitwise or of all elements in an ndarray.

See the documentation for L</borover> for more information.

=for usage

 $x = bor($data);

=for bad

This routine handles bad values.

=cut

*bor = \&PDL::bor;
sub PDL::bor {
	my($x) = @_; my $tmp;
	$x->clump(-1)->borover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1896 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 min

=for ref

Return the minimum of all elements in an ndarray.

See the documentation for L</minimum> for more information.

=for usage

 $x = min($data);

=for bad

This routine handles bad values.

=cut

*min = \&PDL::min;
sub PDL::min {
	my($x) = @_; my $tmp;
	$x->clump(-1)->minimum( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1926 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 max

=for ref

Return the maximum of all elements in an ndarray.

See the documentation for L</maximum> for more information.

=for usage

 $x = max($data);

=for bad

This routine handles bad values.

=cut

*max = \&PDL::max;
sub PDL::max {
	my($x) = @_; my $tmp;
	$x->clump(-1)->maximum( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1956 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 median

=for ref

Return the median of all elements in an ndarray.

See the documentation for L</medover> for more information.

=for usage

 $x = median($data);

=for bad

This routine handles bad values.

=cut

*median = \&PDL::median;
sub PDL::median {
	my($x) = @_; my $tmp;
	$x->clump(-1)->medover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 1986 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 mode

=for ref

Return the mode of all elements in an ndarray.

See the documentation for L</modeover> for more information.

=for usage

 $x = mode($data);

=for bad

This routine handles bad values.

=cut

*mode = \&PDL::mode;
sub PDL::mode {
	my($x) = @_; my $tmp;
	$x->clump(-1)->modeover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 2016 "Ufunc.pm"



#line 543 "ufunc.pd"

=head2 oddmedian

=for ref

Return the oddmedian of all elements in an ndarray.

See the documentation for L</oddmedover> for more information.

=for usage

 $x = oddmedian($data);

=for bad

This routine handles bad values.

=cut

*oddmedian = \&PDL::oddmedian;
sub PDL::oddmedian {
	my($x) = @_; my $tmp;
	$x->clump(-1)->oddmedover( $tmp=PDL->nullcreate($x) );
	$tmp;
}
#line 2046 "Ufunc.pm"



#line 573 "ufunc.pd"


=head2 any

=for ref

Return true if any element in ndarray set

Useful in conditional expressions:

=for example

 if (any $x>15) { print "some values are greater than 15\n" }

=for bad

See L</or> for comments on what happens when all elements
in the check are bad.

=cut

*any = \&or;
*PDL::any = \&PDL::or;

=head2 all

=for ref

Return true if all elements in ndarray set

Useful in conditional expressions:

=for example

 if (all $x>15) { print "all values are greater than 15\n" }

=for bad

See L</and> for comments on what happens when all elements
in the check are bad.

=cut

*all = \&and;
*PDL::all = \&PDL::and;

=head2 minmax

=for ref

Returns a list with minimum and maximum values of an ndarray.

=for usage

 ($mn, $mx) = minmax($pdl);

This routine does I<not> broadcast over the dimensions of C<$pdl>;
it returns the minimum and maximum values of the whole ndarray.
See L</minmaximum> if this is not what is required.
The two values are returned as Perl scalars,
and therefore ignore whether the values are bad.

=for example

 pdl> $x = pdl [1,-2,3,5,0]
 pdl> ($min, $max) = minmax($x);
 pdl> p "$min $max\n";
 -2 5

=cut

*minmax = \&PDL::minmax;
sub PDL::minmax {
  my ($x)=@_; my $tmp;
  my @arr = $x->clump(-1)->minmaximum;
  map $_->sclr, @arr[0,1]; # as scalars !
}
#line 2128 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 medover

=for sig

  Signature: (a(n); [o]b(); [t]tmp(n))


=for ref

Project via median to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the median along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = medover($x);

=for example

 $spectrum = medover $image->transpose





=for bad

medover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2172 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*medover = \&PDL::medover;
#line 2179 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 oddmedover

=for sig

  Signature: (a(n); [o]b(); [t]tmp(n))


=for ref

Project via oddmedian to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the oddmedian along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = oddmedover($x);

=for example

 $spectrum = oddmedover $image->transpose



The median is sometimes not a good choice as if the array has
an even number of elements it lies half-way between the two
middle values - thus it does not always correspond to a data
value. The lower-odd median is just the lower of these two values
and so it ALWAYS sits on an actual data value which is useful in
some circumstances.
	



=for bad

oddmedover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2231 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*oddmedover = \&PDL::oddmedover;
#line 2238 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 modeover

=for sig

  Signature: (data(n); [o]out(); [t]sorted(n))


=for ref

Project via mode to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the mode along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = modeover($x);

=for example

 $spectrum = modeover $image->transpose


The mode is the single element most frequently found in a 
discrete data set.

It I<only> makes sense for integer data types, since
floating-point types are demoted to integer before the
mode is calculated.

C<modeover> treats BAD the same as any other value:  if
BAD is the most common element, the returned value is also BAD.




=for bad

modeover does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2292 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*modeover = \&PDL::modeover;
#line 2299 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 pctover

=for sig

  Signature: (a(n); p(); [o]b(); [t]tmp(n))


=for ref

Project via specified percentile to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the specified percentile along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = pctover($x);

=for example

 $spectrum = pctover $image->transpose

The specified
percentile must be between 0.0 and 1.0.  When the specified percentile
falls between data points, the result is interpolated.  Values outside
the allowed range are clipped to 0.0 or 1.0 respectively.  The algorithm
implemented here is based on the interpolation variant described at
L<http://en.wikipedia.org/wiki/Percentile> as used by Microsoft Excel
and recommended by NIST.




=for bad

pctover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2350 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*pctover = \&PDL::pctover;
#line 2357 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 oddpctover

=for sig

  Signature: (a(n); p(); [o]b(); [t]tmp(n))


=for ref

Project via specified percentile to N-1 dimensions

This function reduces the dimensionality of an ndarray
by one by taking the specified percentile along the 1st dimension.

By using L<xchg|PDL::Slices/xchg> etc. it is possible to use
I<any> dimension.

=for usage

 $y = oddpctover($x);

=for example

 $spectrum = oddpctover $image->transpose

The specified
percentile must be between 0.0 and 1.0.  When the specified percentile
falls between two values, the nearest data value is the result.
The algorithm implemented is from the textbook version described
first at L<http://en.wikipedia.org/wiki/Percentile>.




=for bad

oddpctover processes bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 2406 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*oddpctover = \&PDL::oddpctover;
#line 2413 "Ufunc.pm"



#line 934 "ufunc.pd"

=head2 pct

=for ref

Return the specified percentile of all elements in an ndarray. The
specified percentile (p) must be between 0.0 and 1.0.  When the
specified percentile falls between data points, the result is interpolated.

=for usage

 $x = pct($data, $pct);

=cut

*pct = \&PDL::pct;
sub PDL::pct {
	my($x, $p) = @_;
	$x->clump(-1)->pctover($p, my $tmp=PDL->nullcreate($x));
	$tmp;
}
#line 2439 "Ufunc.pm"



#line 934 "ufunc.pd"

=head2 oddpct

=for ref

Return the specified percentile of all elements in an ndarray. The
specified percentile (p) must be between 0.0 and 1.0.  When the
specified percentile falls between data points, the nearest data value is the result.

=for usage

 $x = oddpct($data, $pct);

=cut

*oddpct = \&PDL::oddpct;
sub PDL::oddpct {
	my($x, $p) = @_;
	$x->clump(-1)->oddpctover($p, my $tmp=PDL->nullcreate($x));
	$tmp;
}
#line 2465 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 qsort

=for sig

  Signature: (a(n); [o]b(n))


=for ref

Quicksort a vector into ascending order.

=for example

 print qsort random(10);



=for bad

Bad values are moved to the end of the array:

 pdl> p $y
 [42 47 98 BAD 22 96 74 41 79 76 96 BAD 32 76 25 59 BAD 96 32 BAD]
 pdl> p qsort($y)
 [22 25 32 32 41 42 47 59 74 76 76 79 96 96 96 98 BAD BAD BAD BAD]


=cut
#line 2501 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*qsort = \&PDL::qsort;
#line 2508 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 qsorti

=for sig

  Signature: (a(n); indx [o]indx(n))


=for ref

Quicksort a vector and return index of elements in ascending order.

=for example

 $ix = qsorti $x;
 print $x->index($ix); # Sorted list



=for bad

Bad elements are moved to the end of the array:

 pdl> p $y
 [42 47 98 BAD 22 96 74 41 79 76 96 BAD 32 76 25 59 BAD 96 32 BAD]
 pdl> p $y->index( qsorti($y) )
 [22 25 32 32 41 42 47 59 74 76 76 79 96 96 96 98 BAD BAD BAD BAD]


=cut
#line 2545 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*qsorti = \&PDL::qsorti;
#line 2552 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 qsortvec

=for sig

  Signature: (a(n,m); [o]b(n,m))


=for ref

Sort a list of vectors lexicographically.

The 0th dimension of the source ndarray is dimension in the vector;
the 1st dimension is list order.  Higher dimensions are broadcasted over.

=for example

 print qsortvec pdl([[1,2],[0,500],[2,3],[4,2],[3,4],[3,5]]);
 [
  [  0 500]
  [  1   2]
  [  2   3]
  [  3   4]
  [  3   5]
  [  4   2]
 ]
 


=for bad

Vectors with bad components are moved to the end of the array:

  pdl> p $p = pdl("[0 0] [-100 0] [BAD 0] [100 0]")->qsortvec

  [
   [-100    0]
   [   0    0]
   [ 100    0]
   [ BAD    0]
  ]


=cut
#line 2603 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*qsortvec = \&PDL::qsortvec;
#line 2610 "Ufunc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 qsortveci

=for sig

  Signature: (a(n,m); indx [o]indx(m))


=for ref

Sort a list of vectors lexicographically, returning the indices of the
sorted vectors rather than the sorted list itself.

As with C<qsortvec>, the input PDL should be an NxM array containing M
separate N-dimensional vectors.  The return value is an integer M-PDL 
containing the M-indices of original array rows, in sorted order.

As with C<qsortvec>, the zeroth element of the vectors runs slowest in the
sorted list.  

Additional dimensions are broadcasted over: each plane is sorted separately,
so qsortveci may be thought of as a collapse operator of sorts (groan).



=for bad

Vectors with bad components are moved to the end of the array as
for L</qsortvec>.


=cut
#line 2649 "Ufunc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*qsortveci = \&PDL::qsortveci;
#line 2656 "Ufunc.pm"





#line 1182 "ufunc.pd"


=head1 AUTHOR

Copyright (C) Tuomas J. Lukka 1997 (lukka@husc.harvard.edu).
Contributions by Christian Soeller (c.soeller@auckland.ac.nz)
and Karl Glazebrook (kgb@aaoepp.aao.gov.au).  All rights
reserved. There is no warranty. You are allowed to redistribute this
software / documentation under certain conditions. For details, see
the file COPYING in the PDL distribution. If this file is separated
from the PDL distribution, the copyright notice should be included in
the file.

=cut
#line 2677 "Ufunc.pm"




# Exit with OK status

1;
