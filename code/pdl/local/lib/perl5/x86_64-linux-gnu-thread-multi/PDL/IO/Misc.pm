#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::IO::Misc;

our @EXPORT_OK = qw(rcols wcols swcols rgrep bswap2 bswap4 bswap8 isbigendian rasc rcube _rasc );
our %EXPORT_TAGS = (Func=>\@EXPORT_OK);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;


   
   our @ISA = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::IO::Misc ;






#line 7 "misc.pd"

use strict;
use warnings;

=head1 NAME

PDL::IO::Misc - misc IO routines for PDL

=head1 DESCRIPTION

Some basic I/O functionality: FITS, tables, byte-swapping

=head1 SYNOPSIS

 use PDL::IO::Misc;

=cut
#line 43 "Misc.pm"






=head1 FUNCTIONS

=cut




#line 47 "misc.pd"


use PDL::Primitive;
use PDL::Types;
use PDL::Options;
use PDL::Bad;
use Carp;
use Symbol qw/ gensym /;
use List::Util;
use strict;
#line 68 "Misc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 bswap2

=for sig

  Signature: (x(); )

=for ref

Swaps pairs of bytes in argument x()

=for bad

bswap2 does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 93 "Misc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*bswap2 = \&PDL::bswap2;
#line 100 "Misc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 bswap4

=for sig

  Signature: (x(); )

=for ref

Swaps quads of bytes in argument x()

=for bad

bswap4 does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 125 "Misc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*bswap4 = \&PDL::bswap4;
#line 132 "Misc.pm"



#line 948 "../../blib/lib/PDL/PP.pm"



=head2 bswap8

=for sig

  Signature: (x(); )

=for ref

Swaps octets of bytes in argument x()

=for bad

bswap8 does not process bad values.
It will set the bad-value flag of all output ndarrays if the flag is set for any of the input ndarrays.


=cut
#line 157 "Misc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*bswap8 = \&PDL::bswap8;
#line 164 "Misc.pm"



#line 124 "misc.pd"




# Internal routine to extend PDL array by size $n along last dimension
# - Would be nice to have a proper extend function rather than hack
# - Is a NO-OP when handed a perl ARRAY ref rather than an ndarray arg
sub _ext_lastD {                           # Called by rcols and rgrep
   my ($x,$n) = @_;
   if (ref($_[0]) ne 'ARRAY') {
      my @nold   = $x->dims;
      my @nnew   = @nold;
      $nnew[-1] += $n;                      # add $n to the last dimension
      my $y      = zeroes($x->type,@nnew);  # New pdl
      my $yy     = $y->mv(-1,0)->slice("0:".($nold[-1]-1))->mv(0,-1);
      $yy       .= $x;
      $_[0]      = $y;
   }
   1;
}

# Implements PDL->at() for either 1D PDL or ARRAY arguments
# TODO: Need to add support for multidim ndarrays parallel to rcols
sub _at_1D ($$) {                           # Called by wcols and swcols
    my $data = $_[0];
    my $index = $_[1];
    
    if (ref $data eq 'ARRAY') {
       return $data->[$index];
    } else {
       return $data->at($index);
    }
}

# squeezes "fluffy" perl list values into column data type
sub _burp_1D {
   my $data = $_[0]->[0]; 
   my $databox = $_[0]->[1];
   my $index = $_[1];

   my $start = $index - @{$databox} + 1;

   my $tmp; # work around for perl -d "feature"
   if (ref $data eq 'ARRAY') {
      push @{$data}, @{$databox};
   } elsif ( ref($databox->[0]) eq "ARRAY" ) {
      # could add POSIX::strtol for hex and octal support but
      # can't break float conversions (how?)
      ($tmp = $data->slice(":,$start:$index")) .= pdl($databox);
   } else {
      # could add POSIX::strtol for hex and octal support but
      # can't break float conversions (how?)
      ($tmp = $data->slice("$start:$index")) .= pdl($databox);
   }
   $_[0] = [ $data, [] ];
}

# taken outside of rcols() to avoid clutter
sub _handle_types ($$$) {
    my $ncols = shift;
    my $deftype = shift;
    my $types = shift;

    barf "Unknown PDL type given for DEFTYPE.\n"
        unless ref($deftype) eq "PDL::Type";

    my @cols = ref($types) eq "ARRAY" ? @$types : ();
        
    if ( $#cols > -1 ) {
        # truncate if required
        $#cols = $ncols if $#cols > $ncols;
        
        # check input values are sensible
        for ( 0 .. $#cols ) {
            barf "Unknown value '$cols[$_]' in TYPES array.\n" 
                unless ref($cols[$_]) eq "PDL::Type";
        }
    }

    # fill in any missing columns
    for ( ($#cols+1) .. $ncols ) { push @cols, $deftype; }

    return @cols;
} # sub: _handle_types


# Whether an object is an IO handle
use Scalar::Util;
sub _is_io_handle {
    my $h = shift;
    # reftype catches almost every handle, except: *MYHANDLE
    # fileno catches *MYHANDLE, but doesn't catch handles that aren't files
    my $reftype = Scalar::Util::reftype($h);
    return defined(fileno($h)) || (defined($reftype) && $reftype eq 'GLOB');
}


=head2 rcols

=for ref

Read specified ASCII cols from a file into ndarrays and perl
arrays (also see L</rgrep>).

=for usage

  Usage:
    ($x,$y,...) = rcols( *HANDLE|"filename", { EXCLUDE => '/^!/' }, $col1, $col2, ... )
             $x = rcols( *HANDLE|"filename", { EXCLUDE => '/^!/' }, [] )
    ($x,$y,...) = rcols( *HANDLE|"filename", $col1, $col2, ..., { EXCLUDE => '/^!/' } )
    ($x,$y,...) = rcols( *HANDLE|"filename", "/foo/", $col1, $col2, ... )

For each column number specified, a 1D output PDL will be
generated.  Anonymous arrays of column numbers generate
2D output ndarrays with dim0 for the column data and dim1
equal to the number of columns in the anonymous array(s).

An empty anonymous array as column specification will
produce a single output data ndarray with dim(1) equal
to the number of columns available.

There are two calling conventions - the old version, where a
pattern can be specified after the filename/handle, and the
new version where options are given as as hash reference.
This reference can be given as either the second or last
argument.

The default behaviour is to ignore lines beginning with
a # character and lines that only consist of whitespace.
Options exist to only read from lines that match, or do
not match, supplied patterns, and to set the types of the
created ndarrays.

Can take file name or *HANDLE, and if no explicit column
numbers are specified, all are assumed. For the allowed types,
see L<PDL::Core/Datatype_conversions>.

Options (case insensitive):

  EXCLUDE or IGNORE
  - ignore lines matching this pattern (default B<'/^#/'>).
  
  INCLUDE or KEEP
  - only use lines which match this pattern (default B<''>).
  
  LINES   
  - a string pattern specifying which line numbers to use.
  Line numbers start at 0 and the syntax is 'a:b:c' to use
  every c'th matching line between a and b (default B<''>).
  
  DEFTYPE
  - default data type for stored data (if not specified, use the type 
  stored in C<$PDL::IO::Misc::deftype>, which starts off as B<double>).
  
  TYPES
  - reference to an array of data types, one element for each column 
  to be read in.  Any missing columns use the DEFTYPE value (default B<[]>).
  
  COLSEP
  - splits on this string/pattern/qr{} between columns of data. Defaults to
  $PDL::IO::Misc::defcolsep.
  
  PERLCOLS
  - an array of column numbers which are to be read into perl arrays
  rather than ndarrays.  Any columns not specified in the explicit list
  of columns to read will be returned after the explicit columns.
  (default B<undef>).

  COLIDS
  - if defined to an array reference, it will be assigned the column
  ID values obtained by splitting the first line of the file in the
  identical fashion to the column data.

  CHUNKSIZE
  - the number of input data elements to batch together before appending
  to each output data ndarray (Default value is 100).  If CHUNKSIZE is
  greater than the number of lines of data to read, the entire file is
  slurped in, lines split, and perl lists of column data are generated.
  At the end, effectively pdl(@column_data) produces any result ndarrays.

  VERBOSE
  - be verbose about IO processing (default C<$PDL::vebose>)

=for example

For example:

  $x      = PDL->rcols 'file1';	        # file1 has only one column of data
  $x      = PDL->rcols 'file2', [];	# file2 can have multiple columns, still 1 ndarray output
                                        # (empty array ref spec means all possible data fields)

  ($x,$y) = rcols 'table.csv', { COLSEP => ',' };  # read CSV data file
  ($x,$y) = rcols *STDOUT;  # default separator for lines like '32 24'

  # read in lines containing the string foo, where the first
  # example also ignores lines that begin with a # character.
  ($x,$y,$z) = rcols 'file2', 0,4,5, { INCLUDE => '/foo/' };
  ($x,$y,$z) = rcols 'file2', 0,4,5, { INCLUDE => '/foo/', EXCLUDE => '' };

  # ignore the first 27 lines of the file, reading in as ushort's
  ($x,$y) = rcols 'file3', { LINES => '27:-1', DEFTYPE => ushort };
  ($x,$y) = rcols 'file3', { LINES => '27:', TYPES => [ ushort, ushort ] };

  # read in the first column as a perl array and the next two as ndarrays
  # with the perl column returned after the ndarray outputs
  ($x,$y,$name) = rcols 'file4', 1, 2   , { PERLCOLS => [ 0 ] };
  printf "Number of names read in = %d\n", 1 + $#$name;

  # read in the first column as a perl array and the next two as ndarrays
  # with PERLCOLS changing the type of the first returned value to perl list ref
  ($name,$x,$y) = rcols 'file4', 0, 1, 2, { PERLCOLS => [ 0 ] };

  # read in the first column as a perl array returned first followed by the
  # the next two data columns in the file as a single Nx2 ndarray 
  ($name,$xy) = rcols 'file4', 0, [1, 2], { PERLCOLS => [ 0 ] };


  NOTES:

  1. Quotes are required on patterns or use the qr{} quote regexp syntax.
  
  2. Columns are separated by whitespace by default, use the COLSEP option
     separator to specify an alternate split pattern or string or specify an
     alternate default separator by setting C<$PDL::IO::Misc::defcolsep> .
  
  3. Legacy support is present to use C<$PDL::IO::Misc::colsep> to set the
     column separator but C<$PDL::IO::Misc::colsep> is not defined by default.
     If you set the variable to a defined value it will get picked up.
  
  4. LINES => '-1:0:3' may not work as you expect, since lines are skipped
     when read in, then the whole array reversed.

  5. For consistency with wcols and rcols 1D usage, column data is loaded
     into the rows of the pdls (i.e., dim(0) is the elements read per column
     in the file and dim(1) is the number of columns of data read.

=cut

use vars qw/ $colsep $defcolsep $deftype /;

$defcolsep = ' ';       # Default column separator
$deftype = double;      # Default type for ndarrays

my $defchunksize = 100; # Number of perl list items to append to ndarray
my $usecolsep;          # This is the colsep value that is actually used

# NOTE: XXX
#  need to look at the line-selection code. For instance, if want
#   lines => '-1:0:3', 
#  read in all lines, reverse, then apply the step
#  -> fix point 4 above
# 
# perhaps should just simplify the LINES option - ie remove
# support for reversed arrays?

sub rcols{ PDL->rcols(@_) }

sub PDL::rcols {
   my $class = shift;
   barf 'Usage ($x,$y,...) = rcols( *HANDLE|"filename", ["/pattern/" or \%options], $col1, $col2, ..., [ \%options] )' 
   if $#_<0;

   my $is_handle = _is_io_handle $_[0];
   my $fh = $is_handle ? $_[0] : gensym;
   open $fh, $_[0] or die "File $_[0] not found\n" unless $is_handle;
   shift;

   # set up default options
   my $opt = new PDL::Options( {
       CHUNKSIZE => undef,
       COLIDS => undef,
       COLSEP => undef,
       DEFTYPE => $deftype,
       EXCLUDE => '/^#/',
       INCLUDE => undef,
       LINES => '',
       PERLCOLS => undef,
       TYPES   => [],
       VERBOSE=> $PDL::verbose,
       } );
   $opt->synonyms( { IGNORE => 'EXCLUDE', KEEP => 'INCLUDE' } );

   # has the user supplied any options
   if ( defined($_[0]) ) {
      # ensure the old-style behaviour by setting the exclude pattern to undef 
      if ( $_[0] =~ m|^/.*/$| )        { $opt->options( { EXCLUDE => undef, INCLUDE => shift } ); }
      elsif ( ref($_[0]) eq "Regexp" ) { $opt->options( { EXCLUDE => undef, INCLUDE => shift } ); }
      elsif ( ref($_[0]) eq "HASH" )   { $opt->options( shift ); }
   }

   # maybe the last element is a hash array as well
   $opt->options( pop ) if defined($_[-1]) and ref($_[-1]) eq "HASH";

   # a reference to a hash array
   my $options = $opt->current();   

   # handle legacy colsep variable
   $usecolsep = (defined $colsep) ? qr{$colsep} : undef;
   $usecolsep = qr{$options->{COLSEP}} if $options->{COLSEP};

   # what are the patterns?
   foreach my $pattern ( qw( INCLUDE EXCLUDE ) ) {
      if ( $options->{$pattern} and ref($options->{$pattern}) ne "Regexp" ) {
         if ( $options->{$pattern} =~ m|^/.*/$| ) {
            $options->{$pattern} =~ s|^/(.*)/$|$1|;
            $options->{$pattern} = qr($options->{$pattern});
         } else {
            barf "rcols() - unable to process $pattern value.\n";
         }
      }
   }

   # CHUNKSIZE controls memory/time tradeoff of ndarray IO
   my $chunksize = $options->{CHUNKSIZE} || $defchunksize;
   my $nextburpindex = -1;

# which columns are to be read into ndarrays and which into perl arrays?
my @end_perl_cols = ();       # unique perl cols to return at end

my @perl_cols = ();           # perl cols index list from PERLCOLS option
@perl_cols = @{ $$options{PERLCOLS} } if $$options{PERLCOLS};

my @is_perl_col;              # true if index corresponds to a perl column
for (@perl_cols) { $is_perl_col[$_] = 1; };
# print STDERR "rcols: \@is_perl_col is @is_perl_col\n";

my ( @explicit_cols )  = @_;  # call specified columns to read
# print STDERR "rcols: \@explicit_cols is @explicit_cols\n";

# work out which line numbers are required
# - the regexp's are a bit over the top
my ( $x, $y, $c );
if ( $$options{LINES} ne '' ) {
   if ( $$options{LINES} =~ /^\s*([+-]?\d*)\s*:\s*([+-]?\d*)\s*$/ ) {
      $x = $1; $y = $2;
   } elsif ( $$options{LINES} =~ /^\s*([+-]?\d*)\s*:\s*([+-]?\d*)\s*:\s*([+]?\d*)\s*$/ ) {
      $x = $1; $y = $2; $c = $3;
   } else {
      barf "rcols() - unable to parse LINES option.\n";
   }
}

# Since we do not know how many lines there are in advance, things get a bit messy
my ( $index_start, $index_end ) = ( 0, -1 );
$index_start  = $x if defined($x) and $x ne '';
$index_end    = $y if defined($y) and $y ne '';
my $line_step = $c || 1;

# $line_rev = 0/1 for normal order/reversed
# $line_start/_end refer to the first and last line numbers that we want
# (the values of which we may not know until we've read in all the file)
my ( $line_start, $line_end, $line_rev );
if ( ($index_start >= 0 and $index_end < 0) ) {
   # eg 0:-1
   $line_rev = 0; $line_start = $index_start;
} elsif ( $index_end >= 0 and $index_start < 0 ) {
   # eg -1:0
   $line_rev = 1; $line_start = $index_end; 
} elsif ( $index_end >= $index_start and $index_start >= 0 ) {
   # eg 0:10
   $line_rev = 0; $line_start = $index_start; $line_end = $index_end;
} elsif ( $index_start > $index_end and $index_end >= 0 ) {
   # eg 10:0
   $line_rev = 1; $line_start = $index_end; $line_end = $index_start;
} elsif ( $index_start <= $index_end ) {
   # eg -5:-1
   $line_rev = 0;
} else {
   # eg -1:-5
   $line_rev = 1;
}

my @ret;

my ($k,$fhline); 

my $line_num = -1;
my $line_ctr = $line_step - 1;  # ensure first line is always included
my $index    = -1;
my $pdlsize  =  0;
my $extend   = 10000;

my $line_store;  # line numbers of saved data

RCOLS_IO: {

   if ($options->{COLIDS}) {
      print STDERR "rcols: processing COLIDS option\n" if $options->{VERBOSE};
      undef $!;
      if (defined($fhline = <$fh>) ) {        # grab first line's fields for column IDs
         $fhline =~ s/\r?\n$//;               # handle DOS on unix files better
         my @v = defined($usecolsep) ? split($usecolsep,$fhline) : split(' ',$fhline);
         @{$options->{COLIDS}} = @v;
      } else {
         die "rcols: reading COLIDS info, $!" if $!;
         last RCOLS_IO;
      }
   }

   while( defined($fhline = <$fh>) ) {

      # chomp $fhline;
      $fhline =~ s/\r?\n$//;  # handle DOS on unix files better

      $line_num++;

      # the order of these checks is important, particularly whether we
      # check for line_ctr before or after the pattern matching
      # Prior to PDL 2.003 the line checks were done BEFORE the
      # pattern matching
      #
      # need this first check, even with it almost repeated at end of loop,
      # incase the pattern matching excludes $line_num == $line_end, say
      last if     defined($line_end)   and $line_num > $line_end;
      next if     defined($line_start) and $line_num < $line_start;
      next if     $options->{EXCLUDE} and     $fhline =~ /$options->{EXCLUDE}/;
      next if     $options->{INCLUDE} and not $fhline =~ /$options->{INCLUDE}/;
      next unless ++$line_ctr == $line_step;
      $line_ctr = 0;

      $index++;
      my @v = defined($usecolsep) ? split($usecolsep,$fhline) : split(' ',$fhline);

      # map empty fields '' to undef value
      @v = map { $_ eq '' ? undef : $_ } @v;

      # if the first line, set up the output ndarrays using all the columns
      # if the user doesn't specify anything
      if ( $index == 0 ) {

         # Handle implicit multicolumns in command line
         if ($#explicit_cols < 0) {                 # implicit single col data
            @explicit_cols = ( 0 .. $#v );
         }
         if (scalar(@explicit_cols)==1 and ref($explicit_cols[0]) eq "ARRAY") {
            if ( !scalar(@{$explicit_cols[0]}) ) {  # implicit multi-col data
               @explicit_cols = ( [ 0 .. $#v ] );
            }
         }
         my $implicit_pdls = 0;
         my $is_explicit = {};
         foreach my $col (@explicit_cols) {
            if (ref($col) eq "ARRAY") {
               $implicit_pdls++ if !scalar(@$col);
            } else {
               $is_explicit->{$col} = 1;
            }
         }
         if ($implicit_pdls > 1) {
            die "rcols: only one implicit multicolumn ndarray spec allowed, found $implicit_pdls!\n";
         }
         foreach my $col (@explicit_cols) {
            if (ref($col) eq "ARRAY" and !scalar(@$col)) {
               @$col = grep { !$is_explicit->{$_} } ( 0 .. $#v );
            }
         }
            
         # remove declared perl columns from pdl data list
         $k = 0;
         my @pdl_cols = ();
         foreach my $col (@explicit_cols) {
            # strip out declared perl cols so they won't be read into ndarrays
            if ( ref($col) eq "ARRAY" ) {
               @$col = grep { !$is_perl_col[$_] } @{$col};
               push @pdl_cols, [ @{$col} ];
            } elsif (!$is_perl_col[$col]) {
               push @pdl_cols, $col;
            }
         }
         # strip out perl cols in explicit col list for return at end
         @end_perl_cols = @perl_cols;
         foreach my $col (@explicit_cols) {
            if ( ref($col) ne "ARRAY" and defined($is_perl_col[$col]) ) {
               @end_perl_cols = grep { $_ != $col } @end_perl_cols;
            }
         };

         # sort out the types of the ndarrays
         my @types = _handle_types( $#pdl_cols, $$options{DEFTYPE}, $$options{TYPES} );
         if ( $options->{VERBOSE} ) { # dbg aid
            print "Reading data into ndarrays of type: [ ";
            foreach my $t ( @types ) {
               print $t->shortctype() . " ";
            }
            print "]\n";
         }

         $k = 0;
         for (@explicit_cols) {
            # Using mixed list+ndarray data structure for performance tradeoff
            # between memory usage (perl list) and speed of IO (PDL operations)
            if (ref($_) eq "ARRAY") {
               # use multicolumn ndarray here
               push @ret, [ $class->zeroes($types[$k++],scalar(@{$_}),1), [] ];
            } else {
               push @ret, ($is_perl_col[$_] ? [ [], [] ] : [ $class->zeroes($types[$k],1), [] ]);
               $k++ unless $is_perl_col[$_];
            }
         }
         for (@end_perl_cols) { push @ret, [ [], [] ]; }

         $line_store = [ $class->zeroes(long,1), [] ]; # only need to store integers
      }

      # if necessary, extend PDL in buffered manner
      $k = 0;
      if ( $pdlsize < $index ) {
         for (@ret, $line_store) { _ext_lastD( $_->[0], $extend ); }
         $pdlsize += $extend;
      }

      # - stick perl arrays onto end of $ret
      $k = 0;
      for (@explicit_cols, @end_perl_cols)  {
         if (ref($_) eq "ARRAY") {
            push @{ $ret[$k++]->[1] }, [ @v[ @$_ ] ];
         } else {
            push @{ $ret[$k++]->[1] }, $v[$_];
         }
      }

      # store the line number
      push @{$line_store->[1]}, $line_num;

      # need to burp out list if needed
      if ( $index >= $nextburpindex ) {
         for (@ret, $line_store) { _burp_1D($_,$index); }
         $nextburpindex = $index + $chunksize;
      }

      # Thanks to Frank Samuelson for this
      last if defined($line_end) and $line_num == $line_end;
   }

}

close($fh) unless $is_handle;

# burp one final time if needed and 
# clean out additional ARRAY ref level for @ret
for (@ret, $line_store) {
   _burp_1D($_,$index) if defined $_ and scalar @{$_->[1]};
   $_ = $_->[0];
}

# have we read anything in? if not, return empty ndarrays
if ( $index == -1 ) {
   print "Warning: rcols() did not read in any data.\n" if $options->{VERBOSE};
   if ( wantarray ) {
      foreach ( 0 .. $#explicit_cols ) {
         if ( $is_perl_col[$_] ) {
            $ret[$_] = PDL->null;
         } else {
            $ret[$_] = [];
         }
      }
      for ( @end_perl_cols ) { push @ret, []; }
      return ( @ret );
   } else { 
      return PDL->null;
   }
}

# if the user has asked for lines => 0:-1 or 0:10 or 1:10 or 1:-1,
# - ie not reversed and the last line number is known -
# then we can skip the following nastiness
if ( $line_rev == 0 and $index_start >= 0 and $index_end >= -1 ) {
   for (@ret) {
      ## $_ = $_->mv(-1,0)->slice("0:${index}")->mv(0,-1) unless ref($_) eq 'ARRAY';
      $_ = $_->mv(-1,0)->slice("0:${index}") unless ref($_) eq 'ARRAY';  # cols are dim(0)
   };
   if ( $options->{VERBOSE} ) {
      if ( ref($ret[0]) eq 'ARRAY' ) {
         print "Read in ", scalar( @{ $ret[0] } ), " elements.\n";
      } else {
         print "Read in ", $ret[0]->nelem, " elements.\n";
      }
   }
   wantarray ? return(@ret) : return $ret[0];
}

# Work out which line numbers we want. First we clean up the ndarray
# containing the line numbers that have been read in
$line_store = $line_store->slice("0:${index}");

# work out the min/max line numbers required
if ( $line_rev ) {
   if ( defined($line_start) and defined($line_end) ) {
      my $dummy = $line_start;
      $line_start = $line_end;
      $line_end = $dummy;
   } elsif ( defined($line_start) ) {
      $line_end = $line_start;
   } else {
      $line_start = $line_end; 
   }
}
$line_start = $line_num + 1 + $index_start if $index_start < 0;
$line_end   = $line_num + 1 + $index_end   if $index_end   < 0;

my $indices;

{ no warnings 'precedence';	
   if ( $line_rev ) {
      $indices = which( $line_store >= $line_end & $line_store <= $line_start )->slice('-1:0');
   } else {
      $indices = which( $line_store >= $line_start & $line_store <= $line_end );
   }
}

# truncate the ndarrays
for my $col ( @explicit_cols ) {
   if ( ref($col) eq "ARRAY" ) {
      for ( @$col ) {
         $ret[$_] = $ret[$_]->index($indices);
      }
   } else {
      $ret[$col] = $ret[$col]->index($indices) unless $is_perl_col[$col] };
}

# truncate/reverse/etc the perl arrays
my @indices_array = list $indices;
foreach ( @explicit_cols, @end_perl_cols ) {
   if ( $is_perl_col[$_] ) {
      my @temp = @{ $ret[$_] };
      $ret[$_] = [];
      foreach my $i ( @indices_array ) { push @{ $ret[$_] }, $temp[$i] };
   }
}

# print some diagnostics
if ( $options->{VERBOSE} ) {
   my $done = 0;
   foreach my $col (@explicit_cols) {
      last if $done;
      next if $is_perl_col[$col];
      print "Read in ", $ret[$col]->nelem, " elements.\n";
      $done = 1;
   }
   foreach my $col (@explicit_cols, @end_perl_cols) {
      last if $done;
      print "Read in ", $ret[$col]->nelem, " elements.\n";
      $done = 1;
   }
}

# fix 2D pdls to match what wcols generates
foreach my $col (@ret) {
   next if ref($col) eq "ARRAY";
   $col = $col->transpose if $col->ndims == 2;
}

wantarray ? return(@ret) : return $ret[0];
}


=head2 wcols

=for ref

  Write ASCII columns into file from 1D or 2D ndarrays and/or 1D listrefs efficiently.

Can take file name or *HANDLE, and if no file/filehandle is given defaults to STDOUT.

  Options (case insensitive):

    HEADER - prints this string before the data. If the string
             is not terminated by a newline, one is added. (default B<''>).

    COLSEP - prints this string between columns of data. Defaults to
             $PDL::IO::Misc::defcolsep.

    FORMAT - A printf-style format string that is cycled through
             column output for user controlled formatting.

=for usage

 Usage: wcols $data1, $data2, $data3,..., *HANDLE|"outfile", [\%options];  # or
        wcols $format_string, $data1, $data2, $data3,..., *HANDLE|"outfile", [\%options];

   where the $dataN args are either 1D ndarrays, 1D perl array refs,
   or 2D ndarrays (as might be returned from rcols() with the [] column
   syntax and/or using the PERLCOLS option).  dim(0) of all ndarrays
   written must be the same size.  The printf-style $format_string,
   if given, overrides any FORMAT key settings in the option hash.

e.g.,

=for example

  $x = random(4); $y = ones(4);
  wcols $x, $y+2, 'foo.dat';
  wcols $x, $y+2, *STDERR;
  wcols $x, $y+2, '|wc';

  $x = sequence(3); $y = zeros(3); $c = random(3);
  wcols $x,$y,$c; # Orthogonal version of 'print $x,$y,$c' :-)

  wcols "%10.3f", $x,$y; # Formatted
  wcols "%10.3f %10.5g", $x,$y; # Individual column formatting

  $x = sequence(3); $y = zeros(3); $units = [ 'm/sec', 'kg', 'MPH' ];
  wcols $x,$y, { HEADER => "#   x   y" };
  wcols $x,$y, { Header => "#   x   y", Colsep => ', ' };  # case insensitive option names!
  wcols " %4.1f  %4.1f  %s",$x,$y,$units, { header => "# Day  Time  Units" };

  $a52 = sequence(5,2); $y = ones(5); $c = [ 1, 2, 4 ];
  wcols $a52;         # now can write out 2D pdls (2 columns data in output)
  wcols $y, $a52, $c  # ...and mix and match with 1D listrefs as well

  NOTES:

  1. Columns are separated by whitespace by default, use
     C<$PDL::IO::Misc::defcolsep> to modify the default value or
     the COLSEP option

  2. Support for the C<$PDL::IO::Misc::colsep> global value
     of PDL-2.4.6 and earlier is maintained but the initial value
     of the global is undef until you set it.  The value will be
     then be picked up and used as if defcolsep were specified.

  3. Dim 0 corresponds to the column data dimension for both
     rcols and wcols.  This makes wcols the reverse operation
     of rcols.

=cut

*wcols = \&PDL::wcols;

sub PDL::wcols {
   barf 'Usage: wcols($optional_format_string, 1_or_2D_pdls, *HANDLE|"filename", [\%options])' if @_<1;

   # handle legacy colsep variable
   $usecolsep = (defined $colsep) ? $colsep : $defcolsep;

   # if last argument is a reference to a hash, parse the options
   my ($format_string, $step, $fh);
   my $header;
   if ( ref( $_[-1] ) eq "HASH" ) {
       my $opt = pop;
       foreach my $key ( sort keys %$opt ) {
           if ( $key =~ /^H/i ) { $header = $opt->{$key}; }             # option: HEADER
	   elsif ( $key =~ /^COLSEP/i ) { $usecolsep = $opt->{$key}; }  # option: COLSEP
	   elsif ( $key =~ /^FORMAT/i ) { $format_string = $opt->{$key}; }  # option: FORMAT
           else {
               print "Warning: wcols does not understand option <$key>.\n";
           }
       }
   }
   if (ref(\$_[0]) eq "SCALAR" || $format_string) {
       $format_string = shift if (ref(\$_[0]) eq "SCALAR");
       # 1st arg not ndarray, explicit format string overrides option hash FORMAT
       $step = $format_string;
       $step =~ s/(%%|[^%])//g;  # use step to count number of format items
       $step = length ($step);
   }
   my $file = $_[-1];
   my $file_opened;
   my $is_handle = !UNIVERSAL::isa($file,'PDL') &&
                   !UNIVERSAL::isa($file,'ARRAY') &&
                   _is_io_handle $file;
   if ($is_handle) {  # file handle passed directly
       $fh = $file; pop;
   }
   else{
       if (ref(\$file) eq "SCALAR") {  # Must be a file name
          $fh = gensym;
         if (!$is_handle) {
            $file = ">$file" unless $file =~ /^\|/ or $file =~ /^\>/;
             open $fh, $file or barf "File $file can not be opened for writing\n";
         }
          pop;
          $file_opened = 1;
       }
       else{  # Not a filehandle or filename, assume something else
              # (probably ndarray) and send to STDOUT
          $fh = *STDOUT;
       }
   }

   my @p = @_;
   my $n = (ref $p[0] eq 'ARRAY') ? $#{$p[0]}+1 : $p[0]->dim(0);
   my @dogp = ();  # need to break 2D pdls into a their 1D pdl components
   for (@p) {
      if ( ref $_ eq 'ARRAY' ) {
         barf "wcols: 1D args must have same number of elements\n" if scalar(@{$_}) != $n;
         push @dogp, $_;
      } else {
         barf "wcols: 1D args must have same number of elements\n" if $_->dim(0) != $n or $_->getndims > 2;
         if ( $_->getndims == 2 ) {
            push @dogp, $_->dog;
         } else {
            push @dogp, $_;
         }
      }
   }
   if ( defined $header ) {
       $header .= "\n" unless $header =~ m/\n$/;
       print $fh $header;
   }
   my $i;
   my $pcnt = scalar @dogp;
   for ($i=0; $i<$n; $i++) {
       if ($format_string) {
           my @d;
	   my $pdone = 0;
           for (@dogp) {
               push @d,_at_1D($_,$i); $pdone++;
               if (@d == $step) {
                   printf $fh $format_string,@d;
                   printf $fh $usecolsep unless $pdone==$pcnt;
                   $#d = -1;
               }
           }
           if (@d && !$i) {
               my $str;
               if ($#dogp>0) {
                   $str = ($#dogp+1).' columns don\'t';
               } else {
                   $str = '1 column doesn\'t';
               }
               $str .= " fit in $step column format ".
               '(even repeated) -- discarding surplus';
               carp $str;
               # printf $fh $format_string,@d;
               # printf $fh $usecolsep;
           }
       } else {
	   my $pdone = 0;
           for (@dogp) {
	       $pdone++;
               print $fh _at_1D($_,$i) . ( ($pdone==$pcnt) ? '' : $usecolsep );
           }
       }
       print $fh "\n";
   }
   close($fh) if $file_opened;
   return 1;
}

=head2 swcols

=for ref

generate string list from C<sprintf> format specifier and a list of ndarrays

C<swcols> takes an (optional) format specifier of the printf
sort and a list of 1D ndarrays as input. It returns a perl
array (or array reference if called in scalar context)
where each element of the array is the string generated by
printing the corresponding element of the ndarray(s) using
the format specified. If no format is specified it uses the
default print format.

=for usage

 Usage: @str = swcols format, pdl1,pdl2,pdl3,...;
    or  $str = swcols format, pdl1,pdl2,pdl3,...;

=cut

*swcols = \&PDL::swcols;

sub PDL::swcols{
  my ($format_string,$step);

  my @outlist;

  if (ref(\$_[0]) eq "SCALAR") {
         $step = $format_string = shift; # 1st arg not ndarray
         $step =~ s/(%%|[^%])//g;  # use step to count number of format items
         $step = length ($step);
  }
  
  my @p = @_;
  my $n = (ref $p[0] eq 'ARRAY') ? $#{$p[0]}+1 : $p[0]->nelem;
  for (@p) {
     if ( ref $_ eq 'ARRAY' ) {
        barf "swcols: 1D args must have same number of elements\n" if scalar(@{$_}) != $n;
     } else {
        barf "swcols: 1D args must have same number of elements\n" if $_->nelem != $n or $_->getndims!=1;
     }
  }

  my $i;
  for ($i=0; $i<$n; $i++) {
         if ($format_string) {
           my @d;
           for (@p) {
                  push @d,_at_1D($_,$i);
                  if (@d == $step) {
                         push @outlist,sprintf $format_string,@d;
                         $#d = -1;
                  }
           }
           if (@d && !$i) {
                  my $str;
                  if ($#p>0) {
                         $str = ($#p+1).' columns don\'t';
                  } else {
                         $str = '1 column doesn\'t';
                  }
                  $str .= " fit in $step column format ".
               '(even repeated) -- discarding surplus';
                  carp $str;
                  # printf $fh $format_string,@d;
                  # printf $fh $usecolsep;
           }
         } else {
           for (@p) {
                  push @outlist,sprintf _at_1D($_,$i),$usecolsep;
           }
         }
  }
  wantarray ? return @outlist: return \@outlist;
}


=head2 rgrep

=for ref

  Read columns into ndarrays using full regexp pattern matching.
  

  Options:
  
  UNDEFINED: This option determines what will be done for undefined 
  values. For instance when reading a comma-separated file of the type 
  C<1,2,,4> where the C<,,> indicates a missing value. 
  
  The default value is to assign C<$PDL::undefval> to undefined values,
  but if C<UNDEFINED> is set this is used instead. This would normally 
  be set to a number, but if it is set to C<Bad> and PDL is compiled
  with Badvalue support (see L<PDL::Bad/>) then undefined values are set to
  the appropriate badvalue and the column is marked as bad.
  
  DEFTYPE: Sets the default type of the columns - see the documentation for
   L</rcols()>
  
  TYPES:   A reference to a Perl array with types for each column - see 
  the documentation for L</rcols()>
  
  BUFFERSIZE: The number of lines to extend the ndarray by. It might speed
  up the reading a little bit by setting this to the number of lines in the
  file, but in general L</rasc()> is a better choice

Usage

=for usage

 ($x,$y,...) = rgrep(sub, *HANDLE|"filename")

e.g.

=for example

 ($x,$y) = rgrep {/Foo (.*) Bar (.*) Mumble/} $file;

i.e. the vectors C<$x> and C<$y> get the progressive values
of C<$1>, C<$2> etc.

=cut

  sub rgrep (&@) {
     barf 'Usage ($x,$y,...) = rgrep(sub, *HANDLE|"filename", [{OPTIONS}])'
         if $#_ > 2;

     my (@ret,@v,$nret); my ($m,$n)=(-1,0); # Count/PDL size
     my $pattern = shift;

     my $is_handle = _is_io_handle $_[0];
     my $fh = $is_handle ? $_[0] : gensym;
     open $fh, $_[0] or die "File $_[0] not found\n" unless $is_handle;

     if (ref($pattern) ne "CODE") {
         die "Got a ".ref($pattern)." for rgrep?!";
     }

	
     # set up default options
     my $opt = new PDL::Options( {
         DEFTYPE => $deftype,
         TYPES => [],
         UNDEFINED => $PDL::undefval,
	 BUFFERSIZE => 10000
         } );
     # Check if the user specified options
     my $u_opt = $_[1] || {};
     $opt->options( $u_opt);

     my $options = $opt->current();   

     # If UNDEFINED is set to .*bad.* then undefined are set to
     # bad - unless we have a Perl that is not compiled with Bad support
     my $undef_is_bad = ($$options{UNDEFINED} =~ /bad/i);
     barf "Unknown PDL type given for DEFTYPE.\n"
        unless ref($$options{DEFTYPE}) eq "PDL::Type";

     while(<$fh>) {
         next unless @v = &$pattern;

         $m++;  # Count got
         if ($m==0) {
           $nret = $#v;   # Last index of values to return

	   # Handle various columns as in rcols - added 18/04/05
           my @types = _handle_types( $nret, $$options{DEFTYPE}, $$options{TYPES} );	
           for (0..$nret) {
                # Modified 18/04/05 to use specified precision.
	 	$ret[$_] = [ PDL->zeroes($types[$_], 1), [] ];
           }
       } else { # perhaps should only carp once...
           carp "Non-rectangular rgrep" if $nret != $#v;
       }
       if ($n<$m) {
           for (0..$nret) {
               _ext_lastD( $ret[$_]->[0], $$options{BUFFERSIZE} ); # Extend PDL in buffered manner
           }
           $n += $$options{BUFFERSIZE};
      }
       for(0..$nret) { 
	# Set values - '1*' is to ensure numeric
	# We now (JB - 18/04/05) also check for defined values or not
	# Ideally this should include Badvalue support..
	if ($v[$_] eq '') {
	   # Missing value - let us treat this specially
	   if ($undef_is_bad) {
	       set $ret[$_]->[0], $m, $$options{DEFTYPE}->badvalue();
               # And set bad flag on $ref[$_]!
               $ret[$_]->[0]->badflag(1);
           } else {
               set $ret[$_]->[0], $m, $$options{UNDEFINED};
           } 
	} else {
    	   set $ret[$_]->[0], $m, 1*$v[$_];
	}
     } 
   }
                                 
   close($fh) unless $is_handle;
   for (@ret) { $_ = $_->[0]->slice("0:$m")->copy; }; # Truncate
   wantarray ? return(@ret) : return $ret[0];
}

=head2 isbigendian

=for ref

  Determine endianness of machine - returns 0 or 1 accordingly

=cut
#line 1221 "Misc.pm"



#line 1180 "misc.pd"

sub PDL::isbigendian { return 0; };
*isbigendian = \&PDL::isbigendian;
#line 1229 "Misc.pm"



#line 1202 "misc.pd"



=head2 rasc

=for ref

  Simple function to slurp in ASCII numbers quite quickly,
  although error handling is marginal (to nonexistent).

=for usage

  $pdl->rasc("filename"|FILEHANDLE [,$noElements]);

      Where:
        filename is the name of the ASCII file to read or open file handle
        $noElements is the optional number of elements in the file to read.
            (If not present, all of the file will be read to fill up $pdl).
        $pdl can be of type float or double (for more precision).

=for example

  #  (test.num is an ascii file with 20 numbers. One number per line.)
  $in = PDL->null;
  $num = 20;
  $in->rasc('test.num',20);
  $imm = zeroes(float,20,2);
  $imm->rasc('test.num');

=cut

sub rasc {PDL->rasc(@_)}
sub PDL::rasc {
  my ($pdl, $file, $num) = @_;
  $num = -1 unless defined $num;
  my $is_openhandle = defined fileno $file;
  my $fi;
  if ($is_openhandle) {
    $fi = $file;
  } else {
    barf 'usage: rasc $pdl, "filename"|FILEHANDLE, [$num_to_read]'
       if !defined $file || ref $file;
    open $fi, "<", $file or barf "Can't open $file";
  }
  $pdl->_rasc(my $ierr=null,$num,$fi);
  close $fi unless $is_openhandle;
  return all $ierr > 0;
}

# ----------------------------------------------------------

=head2 rcube

=for ref

 Read list of files directly into a large data cube (for efficiency)

=for usage

 $cube = rcube \&reader_function, @files;

=for example

 $cube = rcube \&rfits, glob("*.fits");

This IO function allows direct reading of files into a large data cube,
Obviously one could use cat() but this is more memory efficient.

The reading function (e.g. rfits, readfraw) (passed as a reference)
and files are the arguments.

The cube is created as the same X,Y dims and datatype as the first
image specified. The Z dim is simply the number of images.

=cut

sub rcube {

    my $reader = shift;

    barf "Usage: blah" unless ref($reader) eq "CODE";

    my $k=0;
    my ($im,$cube,$tmp,$nx,$ny);
    my $nz = scalar(@_);

    for my $file (@_) {
       print "Slice ($k) - reading file $file...\n" if $PDL::verbose;
       $im = &$reader($file);
       ($nx, $ny) = dims $im;
       if ($k == 0) {
          print "Creating $nx x $ny x $nz cube...\n" if $PDL::verbose;
          $cube = $im->zeroes($im->type,$nx,$ny,$nz);
        }
        else {
          barf "Dimensions do not match for file $file!\n" if
             $im->getdim(0) != $nx or $im->getdim(1) != $ny ;

       }
       $tmp = $cube->slice(":,:,($k)");
       $tmp .= $im;
       $k++;
      }

      return $cube;
}
#line 1340 "Misc.pm"



#line 950 "../../blib/lib/PDL/PP.pm"

*_rasc = \&PDL::_rasc;
#line 1347 "Misc.pm"





#line 27 "misc.pd"


=head1 AUTHOR

Copyright (C) Karl Glazebrook 1997, Craig DeForest 2001,
2003, and Chris Marshall 2010. All rights reserved. There is
no warranty. You are allowed to redistribute this software
/ documentation under certain conditions. For details, see
the file COPYING in the PDL distribution. If this file is
separated from the PDL distribution, the copyright notice
should be included in the file.

=cut
#line 1367 "Misc.pm"




# Exit with OK status

1;
