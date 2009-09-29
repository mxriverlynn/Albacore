# Welcome to the Albacore project.

Albacore is intended to be a professional quality suite of Rake tasks to help automate the process of building a .NET based system. All tasks are built using a test-first approach through rspec, and all tests are included in the Albacore gem.

## How To Install Albacore:

**Step 1:** Setup github as a gem source

> `gem source -a http://gems.github.com`

(note: you only need to do this once for any given computer that is going to install gems from github.)

**Step 2:** Install the Albacore gem

> `gem install derickbailey-Albacore`

## How To Use Albacore

After installing Albacore, you only need to

> `require 'albacore'`

in your rakefile. This will allow you to use the tasks that Albacore includes. Beyond the simple require statement, check out the [Albacore Wiki](http://wiki.github.com/derickbailey/Albacore) for detailed instructions on how to use the built in tasks and their options.