## perlbrew 

**perlbrew** is a tool to manage multiple perl installations in your $HOME 
directory (or wherever you specify). They are completely isolated perl 
universes, and has no relationship with system perl (this is the perl that
is installed in your operating system). 

If you have never used perlbrew before, but use perl regularly, then you
very likely use system perl. 

You can install perlbrew in ubuntu with:

```
$ sudo apt install perlbrew
```

perlbrew can install any version of perl that is available. You can find out 
which versions are available by:

```
$ perlbrew available

   perl-5.35.3
   perl-5.34.0
   perl-5.32.1
   perl-5.30.3
   perl-5.28.3
   perl-5.26.3
   perl-5.24.4
   perl-5.22.4
   perl-5.20.3
   perl-5.18.4
   perl-5.16.3
   perl-5.14.4
   perl-5.12.5
   perl-5.10.1
    perl-5.8.9
    perl-5.6.2
  perl5.005_03
  perl5.004_05
```

Before you can install for the first time, you need to initalize perlbrew, 
which you can do by:

```
$ perlbrew init

perlbrew root (~/perl5/perlbrew) is initialized.

Append the following piece of code to the end of your ~/.profile and start a
new shell, perlbrew should be up and fully functional from there:

    source ~/perl5/perlbrew/etc/bashrc

Simply run `perlbrew` for usage details.

Happy brewing!
```

**Note:** You may need to set you terminal emulator to run as a login shell.

You can install the version you want. You can do this by:

```
$ perlbrew install perl-5.34.0
$ perlbrew install perl-5.28.0
```

You have just installed two versions of perl. Version 5.34 and 5.28. You can
select version 5.34 by:

```
$ perlbrew switch perl-5.34.0
```

If you want to switch to perl-5.28.0 then:

```
$ perlbrew switch perl-5.28.0

```

**Note:** switch is switching perlbrew to always use the latest one you
selected.

Now, when you run perl, you will run the version you have switched to.

Say, you have multiple perl versions installed. In this instance, perl
version 5.34 and 5.28. You have set the perlbrew to 5.34 as default, but
wish to use version 5.28 for this session. Then you can do:

```
$ perlbrew use perl-5.28.0
```

This will open a subshell and allow you to use perl version 5.28.0. You can
check this by typing ```perl -v``` . Type ```exit``` to get out of the 
sub-shell. When you get out, you are back to version 5.34.

perlbrew is great for testing your perl code across multiple perl versions.
You can test your script on all perl versions that you have installed with
perlbrew by running the following command:


```
$ perlbrew exec perl myprogram.pl
```

If you want to use system perl for a particular session, you can do:

```
$ perlbrew off
```

You are now in system perl for this session. If you want to switch off
perlbrew completely and switch to system perl, then do:

```
$ perlbrew switch-off
```

You can switch on perlbrew by simply typing:
```
$ perlbrew switch [perlversion]
```

If you want to see the perl versions that you have installed (by perlbrew), 
you can do the following:

```
$ perlbrew list
```

perlbrew allows you to easily uninstall the perl versions that you installed
and clean the tarbals and build directories with:

```
$ perlbrew uninstall [perlversion]
```

```
$ perlbrew clean
```

Now you will probably want to install cpan modules and for this you may need
cpanm.

```
$ perlbrew install-cpanm
```

Now you can install cpan modules with cpanm:
```
$ cpanm XML::Twig
```

This command will install cpan modules for the currently selected perl install.
If you want to clone the modules to other versions, you can:

```
$ perlbrew clone-modules
```

### Why do we want to use perlbrew?
This approach has many benefits:

* No need to run sudo to install CPAN modules, any more.
* Try the monthly released new perls with ease and learn new language features.
* Test your code against different perl versions.
* Leave vendor perl (the one that comes with OS) alone and avoid multiple 
  hazards
* Vendor perl usually serves its own purposes, and it might be a bad idea to 
  mess it up too much.
* Especially PITA when trying to upgrade system perl.
* Some vendors introduced their own perl bugs, twice!
* Hacking perl internals.
* Just to keep up with fashion. 

