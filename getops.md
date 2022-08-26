## Command Line Options

Perl is a great alternative to bash for creating a command line utility. Bash is
a convenient language for creating shell scripts on linux, but once your utility
gets a little more complicated, the niceness of perl as a language and all the
features that come with it are extremely useful.

As a general use case, I still use bash, when all I want to do is run a set of
linux commands. Once I start needing if-else statements, loops, functions, I
move on to perl. Yes, bash has these features, but the code and syntax is ugly
and difficult to read. Perl is available on all linux systems, and it is an
extremely useful utility here.

If you want to be POSIX compliant, you will benefit from the ```Getopt::Long``` 
module when creating command line utilities.

> This function adheres to the POSIX syntax for command line options, with GNU 
> extensions. In general, this means that options have long names instead of 
> single letters, and are introduced with a double dash "--". Support for 
> bundling of command line options, as was the case with the more traditional 
> single-letter approach, is provided but not enabled by default.

Let's start by creating a simple command line utility.

Here we create a utility called hogwarts that does a few cool things. It takes
as options spell, house and rival. It can take as argument the name of a 
Harry Potter character. Since this is a tutorial script, the options and 
names of characters are limited.

```perl
#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long;
use experimental 'signatures';

=pod

=head1 NAME 

  hogwarts

=head1 USAGE

 hogwarts [OPTION] [Student First Name]

 -s, --spell   favorite spell. 
 -h, --house   the house of the school
 -r, --rival   The person who the named character will attack
 -d, --doc     For instructions on how to get documentation.

=head1 DESCRIPTION

  This utility is limited to a few characters from the Harry Potter universe.

  Harry who is in Gryffindor House and likes to use Expelliarmus. 
  Hermione who is in Gryffindor House and likes Wingardium Leviosa. 
  Voldemort who is in Sytherin House and likes Avada Kedavra. 
  Snape who is in Sytherin House and likes Serpensortia. 

=cut

if (!$ARGV[0]) {
  die "Error! USAGE: hogwarts [OPTION] [Student First Name]\n";
}

my $spell = "";
my $house = "";
my $rival = "";
my $doc;
my @friends;

GetOptions("spell=s" => \$spell,
           "house=s" => \$house,
           "rival=s" => \$rival,
           "friends=s" => \@friends,
           "doc"    => \$doc);

if (defined $doc) {
  print "Get documentation by:\nUSAGE: perldoc hogwarts\n";
  exit;
}


my $name = $ARGV[0];

if ($name eq "Harry") {
  $spell = $spell?$spell:"Expelliarmus";
  $house = "Gryffindor";
  $rival = $rival?$rival:"Malfoy";
  @friends = @friends?@friends:"Ron Hermione";
}
elsif ($name eq "Hermione") {
  $spell = $spell?$spell:"Wingardium Leviosa";
  $house = "Gryffindor";
  $rival = $rival?$rival:"Bellatrix";
  @friends = @friends?@friends:"Ron Harry";
}
elsif ($name eq "Voldemort") {
  $spell = $spell?$spell:"Avada Kedavra";
  $house = "Slytherin";
  $rival = $rival?$rival:"Dumbledore";
  @friends = @friends?@friends:"Death Eaters";
}
elsif ($name eq "Snape") {
  $spell = $spell?$spell:"Serpensortia";
  $house = "Slytherin";
  $rival = $rival?$rival:"James";
  @friends = @friends?@friends:"Lily";
}

print "$name from $house house attacked $rival with the $spell spell\n";
print "$name has friends: @friends\n";
```

Start by loading the ```Getopt::Long`` module. This is the module that allows
you to add POSIX style options.

```perl
use Getopt::Long;
```

Since this snippet code is only useful if you provide the name of a Harry
Potter character, we must pass it an argument. The following bit checks
for the existence of an argument. 

```perl
if (!$ARGV[0]) {
  die "Error! USAGE: hogwarts [OPTION] [Student First Name]\n";
}
```

**Note:** Please remember that an argument is different from an option.
Sometimes, we call options as flags.

The following bits of code sets up the options for the hogwarts perl script. We
start my creating variables for each of them. GetOptions() will grab the options
as you input them from the command line and store them in these variables.

```perl
my $spell = "";
my $house = "";
my $rival = "";
my $doc;
my @friends;

GetOptions("spell=s" => \$spell,
           "house=s" => \$house,
           "rival=s" => \$rival,
           "friends=s" => \@friends,
           "doc"    => \$doc);
```

GetOptions() takes a hash data structure. The left hand side is the longname of 
an option. POSIX/GNU allow short and long names for options. Short names are
usually preceded by a single dash followed by an alpha character (-h, -v). Long 
names are usually preceded by two dashes and a word (--help, --verbose).

Let's elaborate on the GetOptions() example here:

        1          2     3
        spell      =     s

1. spell says allow for an option --spell or -s that takes a value. 
2. This can be = or :. colon says the option can have a value but it is optional.
   Whereas when it is =, the value is required.
3. The value is of type string (s). Other types include integer (i), floating point 
   value (f).

In the example above, spell=s is an option that requires a string value. doc is an
option that takes no value. friends is an options that take one or more strings as
values.

With @friends, you can pass arguments as follows:

```perl
perl hogwarts Harry --friends Ron\ Hermione\ Ginny
```

Here the backslashes are so that we escape the spaces. You can also do:

```perl
perl hogwarts Harry --friends Ron --friends Hermione -f Ginny
```

The produce the same result.

The rest of the perl code is merely some if/else, to get some results.
