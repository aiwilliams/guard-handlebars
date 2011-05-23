# Guard::Handlebars

Guard::Handlebars compiles your Handlebars automatically when files are modified.

Tested on MRI Ruby 1.8.7, 1.9.2 and the latest versions of JRuby & Rubinius.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

Install the gem:

    gem install guard-handlebars

Add it to your `Gemfile`, preferably inside the development group:

    gem 'guard-handlebars'

Add guard definition to your `Guardfile` by running this command:

    guard init handlebars

## Usage

Please read the [Guard usage documentation](https://github.com/guard/guard#readme).

## Guardfile

Guard::Handlebars can be adapted to all kind of projects. Please read the
[Guard documentation](https://github.com/guard/guard#readme) for more information about the Guardfile DSL.

In addition to the standard configuration, this Guard has a short notation for configure projects with a single input a output
directory. This notation creates a watcher from the `:input` parameter that matches all Handlebars files under the given directory
and you don't have to specify a watch regular expression.

### Standard ruby gem

    guard 'handlebars', :input => 'handlebars', :output => 'javascripts'

### Rails app

    guard 'handlebars', :input => 'app/views', :output => 'public/javascripts/compiled'

## Options

There following options can be passed to Guard::Handlebars:

    :input => 'handlebars'              # Relative path to the input directory, default: nil
    :output => 'javascripts'            # Relative path to the output directory, default: nil
    :bare => true                       # Compile without the top-level function wrapper, default: false
    :shallow => true                    # Do not create nested output directories, default: false
    :hide_success => true               # Disable successful compilation messages, default: false

### Nested directories

The guard detects by default nested directories and creates these within the output directory. The detection is based on the match
of the watch regular expression:

A file

    /app/views/mycontroller/myview.handlebars

that has been detected by the watch

    watch(%r{app/views/(.+\.handlebars)})

with an output directory of

    :output => 'public/javascripts/compiled'

will be compiled to

    public/javascripts/compiled/mycontroller/myview.js

Note the parenthesis around the `.+\.handlebars`. This enables Guard::Handlebars to place the full path that was matched inside the
parenthesis into the proper output directory.

This behavior can be switched off by passing the option `:shallow => true` to the guard, so that all JavaScripts will be compiled
directly to the output directory.

### Multiple source directories

The Guard short notation

    guard 'handlebars', :input => 'app/views', :output => 'public/javascripts/compiled'

will be internally converted into the standard notation by adding `(.+\.handlebars)` to the `input` option string and create a Watcher
that is equivalent to:

    guard 'handlebars', :output => 'public/javascripts/compiled' do
      watch(%r{app/views/(.+\.handlebars)})
    end

To add a second source directory that will be compiled to the same output directory, just add another watcher:

    guard 'handlebars', :input => 'app/views', :output => 'public/javascripts/compiled' do
      watch(%r{lib/views/(.+\.handlebars)})
    end

which is equivalent to:

    guard 'handlebars', :output => 'public/javascripts/compiled' do
      watch(%r{app/views/(.+\.handlebars)})
      watch(%r{lib/handlebars/(.+\.handlebars)})
    end

## Development

- Source hosted at [GitHub](https://github.com/aiwilliams/guard-handlebars)
- Report issues/Questions/Feature requests on [GitHub Issues](https://github.com/aiwilliams/guard-handlebars/issues)

Pull requests are very welcome! Make sure your patches are well tested.

 ## Acknowledgment

I took the [Guard::CoffeeScript](https://github.com/netzpirat/guard-coffeescript) code base and renamed
stuff as a first pass. It helped me to learn Guard, and was pretty much what I wanted to be doing. I love
open source software!!

The [Guard Team](https://github.com/guard/guard/contributors) for giving us such a nice pice of software
that is so easy to extend, one *has* to make a plugin for it!

All the authors of the numerous [Guards](https://github.com/guard) available for making the Guard ecosystem
so much growing and comprehensive.

## License

(The MIT License)

Copyright (c) 2011 Adam Williams
Portions Copyright (c) 2010 - 2011 Michael Kessler

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

