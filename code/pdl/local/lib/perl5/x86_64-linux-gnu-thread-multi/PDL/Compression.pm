#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Compression;

our @EXPORT_OK = qw(rice_compress rice_expand );
our %EXPORT_TAGS = (Func=>\@EXPORT_OK);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;


   
   our @ISA = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Compression ;






#line 5 "compression.pd"


=head1 NAME

PDL::Compression - compression utilities

=head1 DESCRIPTION

These routines generally accept some data as a PDL and compress it
into a smaller PDL.  Algorithms typically work on a single dimension
and broadcast over other dimensions, producing a broadcasted table of
compressed values if more than one dimension is fed in.

The Rice algorithm, in particular, is designed to be identical to the
RICE_1 algorithm used in internal FITS-file compression (see PDL::IO::FITS).

=head1 SYNOPSIS

 use PDL::Compression

 ($y,$xsize) = $x->rice_compress();
 $c = $y->rice_expand($xsize);

=cut

use strict;
use warnings;
#line 53 "Compression.pm"






=head1 FUNCTIONS

=cut




#line 74 "compression.pd"


=head1 METHODS

=cut
#line 73 "Compression.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 rice_compress

=for sig

  Signature: (in(n); [o]out(m); int[o]len(); int blocksize)

=for ref

Squishes an input PDL along the 0 dimension by Rice compression.  In
scalar context, you get back only the compressed PDL; in list context,
you also get back ancillary information that is required to uncompress
the data with rice_uncompress.  

Multidimensional data are broadcasted over - each row is compressed
separately, and the returned PDL is squished to the maximum compressed
size of any row.  If any of the streams could not be compressed (the
algorithm produced longer output), the corresponding length is set to -1
and the row is treated as if it had length 0.

Rice compression only works on integer data types -- if you have
floating point data you must first quantize them.

The underlying algorithm is identical to the Rice compressor used in
CFITSIO (and is used by PDL::IO::FITS to load and save compressed FITS
images).

The optional blocksize indicates how many samples are to be compressed
as a unit; it defaults to 32.

How it works:

Rice compression is a subset of Golomb compression, and works on data sets
where variation between adjacent samples is typically small compared to the
dynamic range of each sample.  In this implementation (originally written
by Richard White and contributed to CFITSIO in 1999), the data are divided
into blocks of samples (by default 32 samples per block).  Each block 
has a running difference applied, and the difference is bit-folded to make
it positive definite.  High order bits of the difference stream are discarded,
and replaced with a unary representation; low order bits are preserved.  Unary
representation is very efficient for small numbers, but large jumps could
give rise to ludicrously large bins in a plain Golomb code; such large jumps
("high entropy" samples) are simply recorded directly in the output stream.

Working on astronomical or solar image data, typical compression ratios of 
2-3 are achieved.

=for usage

  $out = $pdl->rice_compress($blocksize);
  ($out, $len, $blocksize, $dim0) = $pdl->rice_compress;

  $new = $out->rice_expand;


=for bad

rice_compress ignores the bad-value flag of the input ndarrays.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 142 "Compression.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

sub PDL::rice_compress {
    my $in = shift;
    my $blocksize = shift || 32;
    ## Reject floating-point inputs
    if( $in->type != byte &&
        $in->type != short &&
	$in->type != ushort &&
	$in->type != long
	) {
	die("rice_compress: input needs to have type byte, short, ushort, or long, not ".($in->type)."\n");
    }
    # output buffer starts the same size; truncate at the end.
    my ($out) = zeroes($in);
    # lengths go here
    my ($len) = zeroes(long, $in->slice("(0)")->dims);
    PDL::_rice_compress_int( $in, $out, $len, $blocksize  );
    my $l = $len->max;
    $out = $out->slice("0:".($l-1))->sever;
    return wantarray ? ($out, $in->dim(0), $blocksize, $len) : $out;
}
#line 168 "Compression.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*rice_compress = \&PDL::rice_compress;
#line 175 "Compression.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 rice_expand

=for sig

  Signature: (in(n); [o]out(m); int blocksize)

=for ref

Unsquishes a PDL that has been squished by rice_compress.

=for usage

     ($out, $len, $blocksize, $dim0) = $pdl->rice_compress;
     $copy = $out->rice_expand($dim0, $blocksize);


=for bad

rice_expand ignores the bad-value flag of the input ndarrays.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 206 "Compression.pm"



#line 949 "../../blib/lib/PDL/PP.pm"

sub PDL::rice_expand {
    my $squished = shift;
    my $dim0 =shift;
    my $blocksize = shift || 32;
    # Allocate output array
    my $out = zeroes( $squished->slice("(0),*$dim0") );
    PDL::_rice_expand_int( $squished, $out, $blocksize );
    return $out;
}
#line 221 "Compression.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*rice_expand = \&PDL::rice_expand;
#line 228 "Compression.pm"





#line 35 "compression.pd"


=head1 AUTHORS

Copyright (C) 2010 Craig DeForest.
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.

The Rice compression library is derived from the similar library in
the CFITSIO 3.24 release, and is licensed under yet more more lenient
terms than PDL itself; that notice is present in the file "ricecomp.c".

=head1 BUGS

=over 3

=item * Currently headers are ignored.  

=item * Currently there is only one compression algorithm.

=back

=head1 TODO

=over 3

=item * Add object encapsulation

=item * Add test suite

=back

=cut
#line 271 "Compression.pm"




# Exit with OK status

1;
