## System Perl is Awesome!

System perl is the perl interpreter that is provided with your operating system.
The popular linux operating systems such as Ubuntu, Debian, Centos, Fedora, all
come with perl pre-installed. This perl is called the system perl. You can
check which version of system perl you have by running:

```bash
$ perl -v

This is perl 5, version 30, subversion 0 (v5.30.0) built for 
x86_64-linux-gnu-thread-multi (with 50 registered patches, see perl -V for more
detail)

Copyright 1987-2019, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Different OSes and their versions come with different versions of Perl. You
as the user don't usually have control over it. System Perl is perfectly
useful and convenient when you want to create and run simple perl scripts.
You can download most CPAN modules and build complex software with it. 
However, when building complex software, you want to ensure that your code
is portable or reusable. Your OS will need to be upgraded at some point, at
least once its LTS (Long Term Support) time frame has expired. If you don't
do so, you will soon find yourself with an obsolete OS and lacking security
bug fixes. Sometimes, the cpan modules you use get updated, or newer version
of perls come out that deprecate some feature that you are using in your code.
You want to ensure that your software package will run no matter what. For this
reason, several best practices have evolved. These include:

* perlbrew
* Carton
* Docker
* Kubernetes

We will cover these in the future.
