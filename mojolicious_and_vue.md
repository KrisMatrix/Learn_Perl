## Mojolicious and Vue


### How do I use Mojolicious and Vue together?

1. Create a project directory. Let's call it project/.

2. In project/, create a cpanfile. 

```bash
cd project/
$ touch cpanfile
```

3. Edit the cpanfile to include Mojolicious.

```bash
echo "requires 'Mojolicious';" > cpanfile
```

4. If you are going to use Vue, you will probably want webpack. For this,
Jan Henning Thorsen, a member of the Perl IRC community has created a 
module called Mojolicious::Plugin::Webpack. Add this to the cpanfile.

```bash
echo "requires 'Mojolicious::Plugin::Webpack';" >> cpanfile
```

**Note:** Pay attention to the '>>'. You are appending.

5. I assume that you have installed carton on the system, If you wish to use
the cpanfile, you will need Carton. Install Carton globally on your system.
Instructions are provided earlier in this document. 

6. Install the modules in cpanfile.

```bash
$ carton install
```

Carton has installed the mojolicious modules into you project1/ directory under
a directory called local/.

7. Create an app using Mojolicious.

```bash
$ carton exec mojo generate app MyApp
```

This will create several files and directories. The tree structure is as 
follows:

```
my_app/
├── my_app.yml
├── lib
│   ├── MyApp
│   │   └── Controller
│   │       └── Example.pm
│   └── MyApp.pm
├── public
│   └── index.html
├── script
│   └── my_app
├── t
│   └── basic.t
└── templates
    ├── example
    │   └── welcome.html.ep
    └── layouts
        └── default.html.ep

9 directories, 8 files
```

8. Go to my_app/. We need to install a bunch of node modules.

```bash
$ cd my_app/
$ npm install vue@next                      #install vue3
$ npm install -D @vue/compiler-sfc          #install vue compile for single file components
$ npm install --save-dev vue-loader@next    #install vue-loader
$ npm install eslint --save-dev             #install eslint
```

You will see a node_modules/ directory under my_app/. You should see a 
package.json in my_app/. 

You should then set up a configuration file for eslint:

```bash
$ ./node_modules/.bin/eslint --init
```

9. You have the initial set up for Vue 3 and Mojo ready. Let's set up a few 
things to make Vue and webpack work. In my_app/ do the following: 

```bash
$ mkdir assets
$ mkdir assets/vue
$ mkdir assets/css
$ mkdir assets/sass
$ touch assets/index.js
$ touch assets/vue/App.vue  #This is the default starting vue component.
                            #Typically called App.vue, but you can name it
                            # what ever you want.
```

10. Let's create a sample App.vue component.

```javascript
<template>
This is the App.vue component.
</template>

<script>
export default {
  
};
</script>
```

11. Modify assets/index.js to import App.vue.

```javascript

import { createApp } from 'vue';
import App from './vue/App.vue';

createApp(App).mount('#app')

```

You have now created a Vue component. 

12. Now, let's go to the template example.

```bash
$ cd templates/example/
$ ls 
welcome.html.ep
```

13. Edit the welcome.html.ep as follows:

```html
% layout 'default';
% title 'Welcome';
<h2><%= $msg %></h2>
<p>
  This page was generated from the template "templates/example/welcome.html.ep"
  and the layout "templates/layouts/default.html.ep",
  <%= link_to 'click here' => url_for %> to reload the page or
  <%= link_to 'here' => '/index.html' %> to move forward to a static page.
</p>

<div id="app"></div>  <!--IMPORTANT ADDITION -->

```

Since we are editing the example template, the important line is the div with 
the id 'app'.

14. In order to use Vue, you need to import it. Now, the way Vue works, you 
cannot import .vue files. This is where webpack comes in, and this is where the
mojolicious plugin comes in.

Navigate back to my_app/ root directory. Edit the file ./lib/MyApp.pm. In the
startup() function, add the line:

```perl
$self->plugin(Webpack => {process => [qw(js css sass vue)]});
```

Now back in my_app/, do the following:

```bash
$ carton exec mojo webpack ./script/my_app
```

This is starting the mojo app and running webpack. After it has completed, exit
by punching CTRL+C.

By running it once, it will webpack has created an assets/ directory under 
./public/. And within this directory, webpack has created the combined js file
called my_app.development.js. If you have also done css, sass, you will see
additional files in this directory. With the my_app.development.js created,
you need to add this file to your layout. You can do this by editing your
layout file ./templates/layouts/default.html.ep.

```html
<!DOCTYPE html>
<html>
  <head>
    <title><%= title %></title>
  </head>
  <body>
    <%= content %>

    %= asset "my_app.js"
  </body>
</html>
```

15. Finally, run the app and check that the component work.

```
$ carton exec mojo webpack ./script/my_app
```

Open a web browser and type localhost:3000. 


# Vue and Mojo 2.0

[temporary notes]

Here is a simple perl script to get you going:

```perl
#!/usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Copy;

=pod

=head1 NAME

create_mojo_vue.pl

=head1 SYNOPSIS

B<USAGE:> perl create_mojo_vue.pl

=head1 DESCRIPTION

Create a Project that uses Mojolicious and Vue frameworks.

=cut

my $projName;
my $appName = "MyApp";
my $app = "my_app";
my $cwd = getcwd();

if (!$ARGV[0]) {
  print "Please enter project name:";
  $projName = <STDIN>;
  chomp $projName;
}
else {
  $projName = $ARGV[0];
}

#Create new mojo project
mkdir $projName;
chdir("$cwd/$projName");

open(my $outFile, ">", "cpanfile") or die "Could not open cpanfile\n";
print $outFile "requires 'Mojolicious';";
close($outFile);

system("carton install");
system("carton exec mojo generate app $appName");
chdir("$cwd/$projName/$app");

open($outFile, ">", "$cwd/$projName/$app/devstart.bat") 
  or die "Could not open devstart.bat\n";
print $outFile <<EOT;
#!/bin/bash

carton exec morbo ./script/my_app
EOT
close($outFile);
system("chmod +x $cwd/$projName/$app/devstart.bat");

system("npm init -y");
system("npm i --save vue\@next vue-loader\@next");
system("npm i -D \@vue/compiler-sfc css-loader style-loader sass-loader sass");
system("npm i -D file-loader url-loader webpack webpack-cli");

#Create webpack.config.js
open($outFile, ">", "$cwd/$projName/$app/webpack.config.js") 
  or die "Could not open webpack.config.js\n";
print $outFile <<"EOT";
const path = require('path')
const { VueLoaderPlugin } = require('vue-loader')

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'public/dist'),
  },
  module: {
    rules: [
      {
        test: \/\\.scss\$\/,
        use: [
          'style-loader',
          'css-loader',
          'sass-loader',
        ],
      },
      {
        test: \/\\.css\$\/,
        use: [
          'style-loader',
          'css-loader',
          'sass-loader',
        ],
      },
      {
        test: \/\\.vue\$\/,
        use: [
          'vue-loader',
        ],
      },
      {
        test: \/\\.png\$\/,
        use: [
          'file-loader',
        ],
      },
    ],
  },

  plugins: [
    new VueLoaderPlugin()
  ],
};
EOT
close($outFile);

open($outFile, ">", "$cwd/$projName/$app/package.json.temp") 
  or die "Could not open package.json.temp\n";
open(my $inFile, "<", "$cwd/$projName/$app/package.json") 
  or die "Could not open package.json\n";
while (my $line = <$inFile>) {
  chomp $line;
  print $outFile "$line\n";
  if ($line =~ m/\"scripts\": \{/) {
    print $outFile "    \"webpk\": \"webpack\",\n";
  }
}
close($inFile);
close($outFile);

copy("package.json.temp","package.json") or die "Copy failed: $!";
unlink("package.json.temp");

#
mkdir "$cwd/$projName/$app/src";
mkdir "$cwd/$projName/$app/src/vue";
open($outFile, ">", "$cwd/$projName/$app/src/index.js")
  or die "Could not open index.js\n";
print $outFile "import App from './vue/App.vue'\n";
print $outFile "import {createApp} from 'vue'\n";
print $outFile "console.log('Groan..Webpack')\n\n";
print $outFile "createApp(App).mount('#app')\n";
close($outFile);

open($outFile, ">", "$cwd/$projName/$app/src/vue/App.vue")
  or die "Could not open App.vue\n";
print $outFile <<"EOT";
<template>

  Hello Vue and Mojo!

</template>

<style scoped>

</style>

<script>
export default {

};
</script>
EOT
close($outFile);

system("npm run webpk");

open($outFile, ">", "$cwd/$projName/$app/templates/layouts/default.html.ep")
  or die "Could not open default.html.ep\n";
print $outFile <<"EOT";
<!DOCTYPE html>
<html>
  <head>
    <title><%= title %></title>
  </head>
  <body>
    <%= content %>

    <script src="<%= url_for '/dist/main.js' %>"></script>
  </body>
</html>
EOT
close($outFile);

open($outFile, ">", "$cwd/$projName/$app/templates/example/welcome.html.ep")
  or die "Could not open welcome.html.ep\n";
print $outFile <<"EOT";
% layout 'default';
% title 'Welcome';

<div id="app">Vue Content</div>

EOT
close($outFile);

chdir($cwd);  #just reset at the end. Not necessary.
```
**Note:** Some tutorials also include mini-css-extract-plugin and 
webpack-dev-server but I have excluded them here as they are not necessary.

This is an initial setup. You may want to add more tests and rules. And maybe
over time more plugins.
