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

**Description:** Create a command line utility that will take as input a csv
file and created a nicely structure space delimited fi

```perl
#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long;

my $data   = "file.dat";
my $length = 24;
my $verbose;
GetOptions ("length=i" => \$length,    # numeric
            "file=s"   => \$data,      # string
            "verbose"  => \$verbose)   # flag
or die("Error in command line arguments\n");
```
