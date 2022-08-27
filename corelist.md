## Corelist - Check for core modules 

Sometimes, perhaps because of limitations imposed on the machine that you are 
working on, you cannot use modules available on CPAN. This is likely because
your machine cannot connect to the internet or more likely due to your 
organization's (employer's) IT rules. 

This is not great place to be because the CPAN has many modules that are 
extremely useful. However, if you have such an imposition, you will benefit
from the command ```corelist```.

```corelist``` is a utility that lets you know whether a modules is a core
module - meaning a module that comes with system perl.

Let's look at two modules HTTP::Tiny and Mojo::Base. One is a core module 
and the other is a module available on CPAN.

```bash
$ corelist HTTP::Tiny

Data for 2019-05-22
HTTP::Tiny was first released with perl v5.13.9
```

```bash
$ corelist Mojo::Base

Data for 2019-05-22
Mojo::Base was not in CORE (or so I think)
```
