# Welcome to the albacore project.

albacore is a professional quality suite of Rake tasks to help automate the process of building a .NET based system. 

## How To Install albacore From Gemcutter Gems:

If you would like to install the current, stable release of albacore, you can do so easily through the standard RubyGems.org server. Follow these simple instructions and you will be good to go.

**Step 1:** Install the albacore gem

> gem install albacore

That's it! You're now equiped with everything you need to get up and running with albacore!

## How To Manually Build And Install The albacore Gem

If you would like to install the latest source code for albacore, and get all the new features and functionality (possibly in an unstable form), you can manually build and install the albacore gem. Follow these simple instructions and you will be good to go.

**Step 1:** Clone albacore

Use your Github account to fork albacore, or clone it directly from my public clone URL.

> git clone git://github.com/derickbailey/albacore.git albacore

**Step 2:** Install Required Dependencies

In your local clone of albacore, run the "install_dependencies.rb" script:

> ruby install_dependencies.rb

This will install all of the gem dependencies that you need, to build the albacore gem.

**Step 3:** Build the gem

In your local clone of albacore, use the jeweler rake tasks to build the latest version of the albacore code into a gem.

> rake jeweler:gemspec
>
> rake jeweler:build

this will produce an 'albacore-#.#.#.gem' file in the 'pkg' folder, where '#.#.#' is the version number. For example 'albacore-0.1.2.gem'.

**Step 4:** Install the gem

After building the gem, you can install it from your local file system.

> gem install -l pkg/albacore-#.#.#.gem

where '#.#.#' is the version number of the gem. For example 'albacore-0.1.2.gem'

## How To Use albacore

On systems do not have the "RUBYOPT" environment variable set to automatically include rubygems, you will also need to add

    require 'rubygems'

to the top of your rakefile. Then, you can add

    require 'albacore'

to your rakefile. This will allow you to use the tasks that albacore includes.  

    desc "Run a sample build using the MSBuildTask"
    msbuild do |msb|
        msb.properties :configuration => :Debug
        msb.targets :Clean, :Build
        msb.solution = "spec/support/TestSolution/TestSolution.sln"
    end

Beyond the simple example, check out the [albacore Wiki](http://wiki.github.com/derickbailey/albacore) for detailed instructions on how to use the built in tasks and their options.

## How To Contribute, Collaborate, Communicate

If you'd like to get involved with the albacore framework, we have a discussion group over at google: **[AlbacoreDev](http://groups.google.com/group/albacoredev)**

Anyone can fork the main repository and submit patches, as well. And lastly, the [wiki](http://wiki.github.com/derickbailey/albacore) and [issues list](http://github.com/derickbailey/albacore/issues) are also open for additions, edits, and discussion.

## Contributors

Many thanks for contributions to albacore are due (in alphabetical order):

* [Andreone](http://github.com/Andreone): Significant Wiki contributions, questions and contributions on the google group
* [Ben Hall](http://github.com/benhall): Primary contributor. SSH, SFTP, ZipDirectory, Rename, YAML auto config, Wiki pages, and many other great additions
* [Brian Donahue](http://github.com/briandonahue): Inspiration and initial code for the ExpandTemplates task
* [Hibri Marzook](http://github.com/hibri): the PLink and NDepend tasks
* [James Gregory](http://github.com/jagregory): the Docu task
* [Kevin Colyar](http://github.com/kevincolyar): Testing and updating of MSBuild to work with Cygwin
* [Mark Wilkins](http://github.com/markwilk): VB.NET Language Generator For The AssemblyInfo Task
* [Mike Nichols](http://github.com/mnichols): XUnit contributions, bug reports, etc
* [Nils Jonsson](http://github.com/njonsson): AssemblyInfo corrections, rakefile corrections
* [Sean Biefeld](http://github.com/seanbiefeld): MSpecTestRunner for NCoverConsole
* [Steven Harman](http://github.com/stevenharman): Finding some wicked bugs, patching nunit test runner, and the nant task
* [Panda Wood](http://github.com/pandawood): NCover Console options and wiki edits
