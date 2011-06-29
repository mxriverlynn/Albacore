# Welcome to the albacore project.

albacore is a suite of Rake tasks to automate the process of building a .NET based system. It's like MSBuild or Nant... but without all the stabby-bracket xmlhell.

## How To Use albacore

Check out the [albacore Wiki](http://wiki.github.com/derickbailey/albacore) for detailed instructions on how to use the built in tasks and their options. 

If you are new to Ruby and Rake, head over to the [getting started](https://github.com/derickbailey/Albacore/wiki/Getting-Started) wiki page.

## Supported Versions Of Ruby And Rake

Albacore has been tested against the following versions of rake:

* Rake v0.8.7
* Rake v0.9.2

Albacore has been tested against the following versions of Ruby for Windows:

* RubyInstaller v1.8.7
* RubyInstaller v1.9.2
* IronRuby v1.0
* IronRuby v1.1
* IronRuby v1.1.1
* IronRuby v1.1.2
* IronRuby v1.1.3

### Unsupported Versions Of Ruby

Support for the following versions of ruby has been dropped. Albacore will no longer be tested against, or have code written to work with these versions of ruby. Use these versions at your own risk.

* RubyInstaller v1.8.6
* RubyInstaller v1.9.1

### Notes About IronRuby

Due to an incompatibility with the Rubyzip gem, IronRuby does not support the ‘zip’ and ‘unzip’ tasks. If you need zip / unzip support, look into using a third party tool such as [7-zip](http://7-zip.org) or [SharpZipLib](http://sharpdevelop.net/OpenSource/SharpZipLib/).

## Contributors

Many thanks for contributions to albacore are due (in alphabetical order):

* [Andreone](http://github.com/Andreone): Significant Wiki contributions, questions and contributions on the google group
* [Andrew Vos](http://github.com/AndrewVos): Fixes and additions to SQLCmd task
* [Ben Hall](http://github.com/benhall): Primary contributor. SSH, SFTP, ZipDirectory, Rename, YAML auto config, Wiki pages, and many other great additions
* [Brett Veenstra](http://github.com/brettveenstra): SQLCmd options (truted connection, batch abort), etc
* [Brian Donahue](http://github.com/briandonahue): Inspiration and initial code for the ExpandTemplates task
* [ChrisAnn](http://github.com/ChrisAnn): MSBuild logger module settings
* [Chris Geihsler](http://github.com/geihsler): MSTest task
* [Dotan Nahum](http://github.com/jondot): NChurn task, Output task, wiki updates, etc
* [Hernan Garcia](http://github.com/hgarcia): Specflow Report task
* [Hibri Marzook](http://github.com/hibri): PLink (deprecated) and NDepend tasks
* [James Gregory](http://github.com/jagregory): Docu task, zip task contributions, nuspec contributions, etc
* [Kevin Colyar](http://github.com/kevincolyar): Testing and updating of MSBuild to work with Cygwin
* [Louis Salin](http://github.com/louissalin): Support for nix path separators in CSC task
* [Mark Boltuc](http://github.com/mboltuc): Fluent Migrator task
* [Mark Wilkins](http://github.com/markwilk): VB.NET Language Generator For The AssemblyInfo Task
* [Mike Nichols](http://github.com/mnichols): XUnit contributions, bug reports, etc
* [Nathan Fisher](:http://github.com/nfisher): additions to CSC task
* [Nils Jonsson](http://github.com/njonsson): AssemblyInfo corrections, rakefile corrections
* [Prabir Shrestha](http://github.com/prabirshrestha): Nupack task, bug fixes for xunit test runner, etc.
* [Panda Wood](http://github.com/pandawood): NCover Console options and wiki edits
* [Sean Biefeld](http://github.com/seanbiefeld): MSpecTestRunner for NCoverConsole
* [Steven Harman](http://github.com/stevenharman): Primary contributor. Nant task, issue tickets, disucssions, and much much more.
* [Steve Hebert](http://github.com/stevehebert): Nuspec task
* [Steven Johnson](http://github.com/2020steve): Expand Templates (deprecated task) supplimental data, etc
* [thomasvm](http://github.com/thomasvm): AssemblyInfo read / update existing file, MSSql additions
* [Tobias Grimm](http://github.com/e-tobi): AssemblyInfo custom\_data, working directory code refactoring, relative project paths for executables

And to anyone and everyone else who has contributed in any way, to the mailing list, spreading the word, blog posts, etc: thank you!

## Legal Mumbo Jumbo (MIT License)

Copyright (c) 2011 Derick Bailey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
