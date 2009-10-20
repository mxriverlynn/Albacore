# Welcome to the Albacore project.

Albacore is intended to be a professional quality suite of Rake tasks to help automate the process of building a .NET based system. All tasks are built using a test-first approach through rspec, and all tests are included in the Albacore gem.

## How To Install Albacore From Gemcutter Gems:

If you would like to install the current, stable release of Albacore, you can do so easily through the Gemcutter gem server. Follow these simple instructions and you will be good to go.

**Step 1:** Setup Gemcutter as a gem source

> gem source -a http://gemcutter.org

(note: you only need to do this once for any given computer that is going to install gems from gemcutter.)

**Step 2:** Install the Albacore gem

> gem install Albacore

## How To Manually Build And Install The Albacore Gem

If you would like to install the latest source code for Albacore, and get all the new features and functionality (possibly in an unstable form), you can manually build and install the Albacore gem. Follow these simple instructions and you will be good to go.

**Step 1:** Clone Albacore

Use your Github account to fork Albacore, or clone it directly from my public clone URL.

> git clone git://github.com/derickbailey/Albacore.git Albacore

**Step 2:** Build the gem

In your local clone of Albacore, use the jeweler rake tasks to build the latest version of the Albacore code into a gem.

> rake jeweler:gemspec
>
> rake jeweler:build

this will produce an 'Albacore-#.#.#.gem' file in the 'pkg' folder, where '#.#.#' is the version number. For example 'Albacore-0.0.1.gem'.

**Step 3:** Install the gem

After building the gem, you can install it from your local file system.

> gem install -l pkg\Albacore-#.#.#.gem

where '#.#.#' is the version number of the gem. For example 'Albacore-0.0.1.gem'

## How To Use Albacore

After installing Albacore, you only need to

    require 'albacore'

in your rakefile. This will allow you to use the tasks that Albacore includes. 

    desc "Run a sample build using the MSBuildTask"
    Albacore::MSBuildTask.new(:msbuild) do |msb|
        msb.properties :configuration => :Debug
        msb.targets [:Clean, :Build]
        msb.solution = "spec/support/TestSolution/TestSolution.sln"
    end

Beyond the simple example, check out the [Albacore Wiki](http://wiki.github.com/derickbailey/Albacore) for detailed instructions on how to use the built in tasks and their options.