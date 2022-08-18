## Carton - The perl module dependency manager!

Carton is a perl module dependency manager created by Miyagawa. One of the
early challenges I had with perl was keeping track of what modules I installed
on my machine. I also did not want modules to be installed across the system
or require super user privileges (sudo). I was concerned about security and 
possible corruption of files. I wanted the ability to control what modules I 
installed, and the ability to remove them at will.

Enter Carton.

You can install carton with cpanm:
```
$ cpanm Carton
```

### How to use Carton?

The benefit of Carton is the ability to install only the modules that you need
for a project. You create a file titled ```cpanfile```. 

```
touch cpanfile
```

In cpanfile, enter the modules you want to use as follows:

```
requires 'XML::LibXML';             # An XML parser module
requires 'Email::Valid', '1.202';   # checks whether the email follows a 
                                    # valid format per RFC.

```

The first line says that you want the XML::LibXML module installed. Carton
will install the latest version of this module available from the CPAN. 

The second line says to installs the module Email::Valid, but requests 
specifically to install version 1.202. This way, if you find that a change
by the module author breaks your use case with this module, you can use
an older version that still functions with you code.

Once you have created your ```cpanfile```, save the file and return to the
command line. To install the modules, run:

```
carton install
```

This will create:
1. a ```local/``` directory if one doesn't already exist,
2. download the modules noted in the ```cpanfile``` from CPAN,
3. install the modules,
4. creates and updates a ```cpanfile.snapshot```.

The ```cpanfile.snapshot``` maintains which perl modules, their dependencies,
and which versions of the modules and dependencies were downloaded from
cpan. This is useful information to have in case you ever need to reinstall
the exact same modules on another machine in the future. If you use git as 
your revision control system and repository management tool, you have the 
option of creating a
.gitignore file. I recommend added the ```local/``` directory in this 
.gitignore file so that you don't upload the modules to a remote cloud
repository like github. Cloud repositories usually have a repository limit
and large modules and projects can quickly eat up this valuable space.

**Did you know?** If you have used a language like Node.JS, the Carton tool
functions similar to the Node Package Manager (npm) tool. cpanfile is 
equivalent to package.json and cpanfile.snapshot is equivalent to 
package-lock.json.

### An Example

For the sake of an example, let's say you have two projects. One
project accepts XML data and creates an html file. The seconds accepts JSON 
data, and creates another JSON file. Now for the first project, you probably
want a cpan module like XML::LibXML. And for the second project, you probably
want the JSON module. The first project doesn't need the JSON module and the
second project doesn't need XML::LibXML module. Here is what you do:

1. Create two directories. One for each project.
```
$ mkdir project1 project2
```

2. In project1 and project2 directories, create a file called ```cpanfile```.

```
$ touch project1/cpanfile
$ touch project2/cpanfile
```

3. Enter the modules you want for each project.

```
$ echo "requires 'XML::LibML'; > project1/cpanfile
$ echo "requires 'JSON'; > project2/cpanfile
```

4. Go to each directory and install the modules.
```
$ cd project1
project1$ carton install

project1$ cd ..
$ cd project2
project2$ carton install
```

5. In each directory, you will now see a new subdirectory called local/. This 
local/ directory will contain the module that you wanted installed.

6. Now in these project directories, you can have your perl scripts. Let's 
call the script project1/ test1.pl and the script in project2/ test2.pl. Here
is sample code:

```
#!/usr/bin/perl
use warnings;
use strict;
use XML::LibXML;

... #other code

__END__
test1.pl
```

```
#!/usr/bin/perl
use warnings;
use strict;
use JSON;

... #other code

__END__
test2.pl
```

If you run these script as:

```bash
perl test1.pl
```

you will get an error, because you are using your system or perlbrew perl
and they don't see the modules installed. The modules are only installed in
the local/ directory. In order to get the program to run correctly, do the
following:

```bash
project1$ carton exec perl test1.pl
```

```bash
project2$ carton exec perl test2.pl
```

You are now using the modules installed with Carton. These modules are now
only in your project directory under local/. If you realize that there is 
an alternate module that you want to use, you can delete local/ and simply
edit the cpanfile to delete and add the module you want, and then reinstall
with ```carton install`. The other nice thing about carton is that you can
select which version of a module you want to use.

```
requires 'Starman', '0.2000';
```

When you install with carton, which uses the cpanfile to determine which
modules to install, it also installs all the dependencies. It also creates
a new file called cpanfile.snapshot. This file shows all the modules and 
dependencies that were installed.

### How is Carton useful?

When you want to move your code from one machine/server to another, simply
copy your project files, the  cpanfile and cpanfile.snapshot. Once moved,
simply install the modules by running ```carton install```.

### Why bother with Carton, when perlbrew can install the cpan modules and clone them for me?

perlbrew can install and clone modules, but it can only do this in the machine
that it is in. When you want to install in a new machine/server, you need to
install perlbrew and then install the perl version(s) you want. The cpan
modules have to be installed manually again. This is where carton proves
useful. Simply install carton in the new machine, then copy the cpan file to 
the new machine, and then run ```carton install```. This will install the 
necessary modules where you want. 
