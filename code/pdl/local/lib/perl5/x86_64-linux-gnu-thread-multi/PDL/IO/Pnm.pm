#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::IO::Pnm;

our @EXPORT_OK = qw(rpnm wpnm pnminraw pnminascii pnmout );
our %EXPORT_TAGS = (Func=>\@EXPORT_OK);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;


   
   our @ISA = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::IO::Pnm ;






#line 9 "pnm.pd"


use strict;
use warnings;

=head1 NAME

PDL::IO::Pnm -- pnm format I/O for PDL

=head1 SYNOPSIS

  use PDL::IO::Pnm;
  $im = wpnm $pdl, $file, $format[, $raw];
  rpnm $stack->slice(':,:,:,(0)'),"PDL.ppm";

=head1 DESCRIPTION

pnm I/O for PDL.

=cut

use PDL::Core qw/howbig convert/;
use PDL::Types;
use PDL::Basic;  # for max/min
use PDL::IO::Misc;
use Carp;
use File::Temp qw( tempfile );

# return the upper limit of data values an integer PDL data type
# can hold
sub dmax {
    my $type = shift;
    my $sz = 8*howbig($type);
    $sz-- if !PDL::Type->new($type)->unsigned;
    return ((1 << $sz)-1);
}
#line 62 "Pnm.pm"






=head1 FUNCTIONS

=cut




#line 948 "../../blib/lib/PDL/PP.pm"



=head2 pnminraw

=for sig

  Signature: (type(); byte+ [o] im(m,n); int ms => m; int ns => n;
			int isbin; PerlIO *fp)


=for ref

Read in a raw pnm file.

read a raw pnm file. The C<type> argument is only there to
determine the type of the operation when creating C<im> or trigger
the appropriate type conversion (maybe we want a byte+ here so that
C<im> follows I<strictly> the type of C<type>).


=for bad

pnminraw does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 105 "Pnm.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*pnminraw = \&PDL::pnminraw;
#line 112 "Pnm.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 pnminascii

=for sig

  Signature: (type(); byte+ [o] im(m,n); int ms => m; int ns => n;
			int format; PerlIO *fp)


=for ref

Read in an ascii pnm file.


=for bad

pnminascii does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 140 "Pnm.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*pnminascii = \&PDL::pnminascii;
#line 147 "Pnm.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 pnmout

=for sig

  Signature: (a(m); int israw; int isbin; PerlIO *fp)


=for ref

Write a line of pnm data.

This function is implemented this way so that broadcasting works
naturally.


=for bad

pnmout does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 177 "Pnm.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*pnmout = \&PDL::pnmout;
#line 184 "Pnm.pm"





#line 47 "pnm.pd"

=head2 rpnm

=for ref

Read a pnm (portable bitmap/pixmap, pbm/ppm) file into an ndarray.

=for usage

  Usage:  $im = rpnm $file;

Reads a file (or open file-handle) in pnm format (ascii or raw) into a pdl (magic numbers P1-P6).
Based on the input format it returns pdls with arrays of size (width,height)
if binary or grey value data (pbm and pgm) or (3,width,height) if rgb
data (ppm). This also means for a palette image that the distinction between
an image and its lookup table is lost which can be a problem in cases (but can
hardly be avoided when using netpbm/pbmplus).  Datatype is dependent
on the maximum grey/color-component value (for raw and binary formats
always PDL_B). rpnm tries to read chopped files by zero padding the
missing data (well it currently doesn't, it barfs; I'll probably fix it
when it becomes a problem for me ;). You can also read directly into an
existing pdl that has to have the right size(!). This can come in handy
when you want to read a sequence of images into a datacube.

For details about the formats see appropriate manpages that come with the
netpbm/pbmplus packages.

=for example

  $stack = zeroes(byte,3,500,300,4);
  rpnm $stack->slice(':,:,:,(0)'),"PDL.ppm";

reads an rgb image (that had better be of size (500,300)) into the
first plane of a 3D RGB datacube (=4D pdl datacube). You can also do
inplace transpose/inversion that way.

=cut

sub rpnm {PDL->rpnm(@_)}
sub PDL::rpnm {
    barf 'Usage: $im = rpnm($file) or $im = $pdl->rpnm($file)'
       if !@_ || @_>3;
    my $pdl = ref($_[1]) && UNIVERSAL::isa($_[1], 'PDL')
      ? (splice @_, 0, 2)[1] : shift->initialize;
    my $file = shift;

    my $fh;
    if (ref $file) {
      $fh = $file;
    } else {
      open $fh, $file or barf "Can't open pnm file '$file': $!";
    }
    binmode $fh;

    read($fh,(my $magic),2);
    barf "Oops, this is not a PNM file" unless $magic =~ /P([1-6])/;
    my $magicno = $1;
    print "reading pnm file with magic $magic\n" if $PDL::debug>1;

    my $israw = $magicno > 3 ? 1 : 0;
    my $isrgb = ($magicno % 3) == 0;
    my $ispbm = ($magicno % 3) == 1;
    my ($params, @dims) = ($ispbm ? 2 : 3, 0, 0, $ispbm ? 1 : 0);
    # get the header information
    my $pgot = 0;
    while (($pgot<$params) && defined(my $line=<$fh>)) {
       $line =~ s/#.*$//;
	next if $line =~ /^\s*$/;    # just white space
	while ($line !~ /^\s*$/ && $pgot < $params) {
	    if ($line =~ /\s*(\S+)(.*)$/) {
		$dims[$pgot++] = $1; $line = $2; }
	    else {
		barf "no valid header info in pnm";}
	}
    }
    # the file ended prematurely
    barf "no valid header info in pnm" if $pgot < $params;
    barf "Dimensions must be > 0" if ($dims[0] <= 0) || ($dims[1] <= 0);

    my ($type) = grep $dims[2] <= dmax($_), $PDL_B,$PDL_US,$PDL_L;
    barf "rraw: data from ascii pnm file out of range" if !defined $type;

    my @Dims = @dims[0,1];
    $Dims[0] *= 3 if $isrgb;
    $pdl = $pdl->zeroes(PDL::Type->new($type),3,@dims[0,1])
      if $pdl->isnull and $isrgb;
    my $npdl = $isrgb ? $pdl->clump(2) : $pdl;
    if ($israw) {
       pnminraw (convert(pdl(0),$type), $npdl, $Dims[0], $Dims[1],
	 $ispbm, $fh);
    } else {
       pnminascii (convert(pdl(0),$type), $npdl, $Dims[0], $Dims[1],
	$magicno, $fh);
    }
    print("loaded pnm file, $dims[0]x$dims[1], gmax: $dims[2]",
	   $isrgb ? ", RGB data":"", $israw ? ", raw" : " ASCII"," data\n")
	if $PDL::debug;

    # need to byte swap for little endian platforms
    $pdl->type->bswap->($pdl) if !isbigendian() and $israw;
    return $pdl;
}

=head2 wpnm

=for ref

Write a pnm (portable bitmap/pixmap, pbm/ppm) file into a file or open file-handle.

=for usage

  Usage:  $im = wpnm $pdl, $file, $format[, $raw];

Writes data in a pdl into pnm format (ascii or raw) (magic numbers P1-P6).
The $format is required (normally produced by B<wpic>) and routine just
checks if data is compatible with that format. All conversions should
already have been done. If possible, usage of B<wpic> is preferred. Currently
RAW format is chosen if compliant with range of input data. Explicit control
of ASCII/RAW is possible through the optional $raw argument. If RAW is
set to zero it will enforce ASCII mode. Enforcing RAW is
somewhat meaningless as the routine will always try to write RAW
format if the data range allows (but maybe it should reduce to a RAW
supported type when RAW == 'RAW'?). For details about the formats
consult appropriate manpages that come with the netpbm/pbmplus
packages.

=cut

my %type2base = (PBM => 1, PGM => 2, PPM => 3);
*wpnm = \&PDL::wpnm;
sub PDL::wpnm {
    barf ('Usage: wpnm($pdl,$filename,$format[,$raw]) ' .
	   'or $pdl->wpnm($filename,$format[,$raw])') if $#_ < 2;
    my ($pdl,$file,$type,$raw) = @_;
    barf "wpnm: unknown format '$type'" if !exists $type2base{$type};

    # need to copy input arg since bswap[24] work inplace
    # might be better if the bswap calls detected if run in
    # void context
    my $swap_inplace = $pdl->is_inplace;

    # check the data
    my @Dims = $pdl->dims;
    barf "wpnm: expecting 3D (3,w,h) input"
	if ($type =~ /PPM/) && (($#Dims != 2) || ($Dims[0] != 3));
    barf "wpnm: expecting 2D (w,h) input"
	if ($type =~ /P[GB]M/) && ($#Dims != 1);
    barf "wpnm: user should convert float etc data to appropriate type"
	if !$pdl->type->integer;
    my $max = $pdl->max;
    barf "wpnm: expecting prescaled data (0-65535)"
	if $pdl->min < 0 or $max > 65535;

    # check for raw format
    my $israw =
      (defined($raw) && !$raw) ? 0 :
      (($pdl->get_datatype == $PDL_B) || ($pdl->get_datatype == $PDL_US) || ($type eq 'PBM')) ? 3 :
      0;

    my $magic = 'P' . ($type2base{$type} + $israw);
    my $isrgb = $type eq 'PPM';

    my $pref = ($file !~ /^\s*[|>]/) ? ">" : "";  # test for plain file name
    my ($already_open, $fh) = 0;
    if (ref $file) {
      $fh = $file, $already_open = 1;
    } else {
      open $fh, $pref . $file or barf "Can't open pnm file: $!";
    }
    binmode $fh;

    print "writing ". ($israw ? "raw" : "ascii") .
      "format with magic $magic, max=$max\n" if $PDL::debug;
    # write header
    print $fh "$magic\n";
    print $fh "$Dims[-2] $Dims[-1]\n";
    if ($type ne 'PBM') {	# fix maxval for raw output formats
       my $outmax = 0;
       if ($max < 256) {
          $outmax =   "255";
       } elsif ($max < 65536) {
          $outmax = "65535";
       } else {
          $outmax = $max;
       };
       print $fh "$outmax\n";
    };

    # if rgb clump first two dims together
    my $out = ($isrgb ? $pdl->slice(':,:,-1:0')->clump(2)
		 : $pdl->slice(':,-1:0'));
    # handle byte swap issues for little endian platforms
    if (!isbigendian() and $israw) {
      $out = $out->copy unless $swap_inplace;
      $out->type->bswap->($out);
    }
    pnmout($out,$israw,$type eq "PBM",$fh);
    # check if our child returned an error (in case of a pipe)
    barf "wpnm: pbmconverter error: $!" if !$already_open and !close $fh;
}



;# Exit with OK status

1;

=head1 BUGS

C<rpnm> currently relies on the fact that the header is separated
from the image data by a newline. This is not required by the p[bgp]m
formats (in fact any whitespace is allowed) but most of the pnm
writers seem to comply with that. Truncated files are currently
treated ungracefully (C<rpnm> just barfs).

=head1 AUTHOR

Copyright (C) 1996,1997 Christian Soeller <c.soeller@auckland.ac.nz>
All rights reserved. There is no warranty. You are allowed
to redistribute this software / documentation under certain
conditions. For details, see the file COPYING in the PDL
distribution. If this file is separated from the PDL distribution,
the copyright notice should be included in the file.


=cut


############################## END PM CODE ################################
#line 420 "Pnm.pm"




# Exit with OK status

1;
