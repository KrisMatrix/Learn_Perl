#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper::Compact qw(ddc);
use Getopt::Long;
use Pod::Usage;

pod2usage(1) unless @ARGV;

#Getopt::Long::Configure('no_auto_abbrev');

my $x = 666;

my %opts = (
    debug => 42,
    foo   => 'Foo!',
    bar   => undef,
    baz   => sub { $x++ },
    test  => 0,
);
GetOptions( \%opts, 
    'debug=i', 
    'foo:s', # Can call as --foo to set ''
    'bar=s',
    'baz=i',
    'list=i@', # Call as --list 1 --list 2 ...
    'help|?',
    'man',
    'verbose!',
    'test|t',
) or pod2usage(2);

pod2usage(1) if $opts{help};
pod2usage( -exitval => 0, -verbose => 2 ) if $opts{man};

#if (my @missing = grep !defined( $opts{$_}), qw(foo bar)) {
#    die 'Missing: ' . join(', ', @missing);
#}

warn ddc \%opts;
warn "x = $x\n";

__END__

=head1 NAME

getopt-long - Illustrate Getopt::Long and Pod::Usage

=head1 SYNOPSIS

  getopt-long [--options]

=head1 OPTIONS

=over 4

=item B<help>

Print a brief help message and exit.

=item B<man>

Print the manual page and exit.

=item B<debug>

Default: 42

=item B<foo>

Default: none

=back

=head1 DESCRIPTION

B<getopt-long> will read the given input and do something useful!

=cut#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper::Compact qw(ddc);
use Getopt::Long;
use Pod::Usage;

pod2usage(1) unless @ARGV;

#Getopt::Long::Configure('no_auto_abbrev');

my $x = 666;

my %opts = (
    debug => 42,
    foo   => 'Foo!',
    bar   => undef,
    baz   => sub { $x++ },
    test  => 0,
);
GetOptions( \%opts, 
    'debug=i', 
    'foo:s', # Can call as --foo to set ''
    'bar=s',
    'baz=i',
    'list=i@', # Call as --list 1 --list 2 ...
    'help|?',
    'man',
    'verbose!',
    'test|t',
) or pod2usage(2);

pod2usage(1) if $opts{help};
pod2usage( -exitval => 0, -verbose => 2 ) if $opts{man};

#if (my @missing = grep !defined( $opts{$_}), qw(foo bar)) {
#    die 'Missing: ' . join(', ', @missing);
#}

warn ddc \%opts;
warn "x = $x\n";

__END__

=head1 NAME

getopt-long - Illustrate Getopt::Long and Pod::Usage

=head1 SYNOPSIS

  getopt-long [--options]

=head1 OPTIONS

=over 4

=item B<help>

Print a brief help message and exit.

=item B<man>

Print the manual page and exit.

=item B<debug>

Default: 42

=item B<foo>

Default: none

=back

=head1 DESCRIPTION

B<getopt-long> will read the given input and do something useful!

=cut
