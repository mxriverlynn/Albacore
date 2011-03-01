NChurn
======

NChurn is a utility that helps asses the churn level of your files in your repository.  
Churn can help you detect which files are changed the most in their life time. This helps identify potential bug hives, and improper design.  
The best thing to do is to plug NChurn into your build process and store history of each run. Then, you can plot the evolution of your repository's churn.  
**Developers see note about building below, if you want to build from source.**

NChurn currently supports file-level churns for

* Git
* Hg (Mercurial)
* SVN
* TFS (Team Foundation)


As outputs, NChurn supports

* Table (plain ASCII)
* CSV
* XML (recommended for builds)


Amongst others, NChurn can also take top # of items to display, cut off churn level, and a date to go back up to. See "Getting Started".

Background
----------------
From this work http://research.microsoft.com/apps/pubs/default.aspx?id=69126

    Code is not static; it evolves over time to meet new requirements. The way code
    evolved in the past can be used to predict its evolution in the future. In particular,
    there is an often accepted notion that code that changes a lot is of lower quality—
    and thus more defect-prone than unchanged code.

    Key Points
    - The more a component has changed (churned), the more likely it is to have
      defects.
    Code churn measures can be used to predict defect-prone components.

NChurn currently gives a view of *file churn* and will hopefully expand into analyzing files and languages themselves in the future.

Getting Started
---------------

	$ NChurn -h
  NChurn 0.4.0.0
  Usage: NChurn
         NChurn -c 4 -d 24-3-2010 -t 10

  d, from-date    Past date to calculate churn from. Absolute in dd-mm-yyyy or
                  number of days back from now.

  c, churn        Minimal churn. Specify either a number for minimum, or float
                  for precent.

  t, top          Return this number of top records.

  r, report       Type of report to output. Use one of: table (default), xml,
                  csv

  a, adapter      Use a specific versioning adapter. Use one of: auto
                  (default), git, tf, svn, hg

  p, env-path     Add to PATH. i.e. for svn.exe you might add "c:\tools". Can
                  add multiple with ;.

  i, input        Get input from a file instead of running a versioning system.
                  Must specify correct adapter via -a.

  x, exclude      Exclude resources matching this regular expression

  n, include      Include resources matching this regular expression

  help            Dispaly this help screen.



Any combination of parameters work.

	$ NChurn -t 5 -c 3        # take top 5, cut off at level 3 and below.
	$ NChurn -c 0.3           # display files that consist 30% of all changes (0.3)
	$ NChurn -d 24-12-2010    # calculate for 24th of Dec, 2010 up to now.
	$ NChurn -c 2 -r xml      # cut off at 2, report output as XML.
	$ NChurn -d 30 -i svn.log -a svn    # go back 30 days, read from pre-made file, adapter is SVN.
	$ NChurn -p c:\tools\svn -a svn     # specify path and adapter on an environment that hasn't got a PATH.
	$ NChurn -x exe$                    # exclude resources that end with 'exe' 

Here is a sample of a run, which cuts off at 8, and uses the default table report:

	$ NChurn -c 8
	+--------------------------------------------------+
	| lib/rubikon/application/instance_methods.rb | 48 |
	| lib/rubikon/application.rb                  | 30 |
	| test/test.rb                                | 30 |
	| lib/rubikon/command.rb                      | 28 |
	| lib/rubikon/parameter.rb                    | 17 |
	| test/application_tests.rb                   | 14 |
	| Rakefile                                    | 13 |
	| lib/rubikon/application/dsl_methods.rb      | 12 |
	| README.md                                   | 11 |
	| samples/helloworld/hello_world.rb           | 11 |
	| lib/rubikon.rb                              | 10 |
	| lib/rubikon/exceptions.rb                   | 10 |
	| lib/rubikon/flag.rb                         | 10 |
	| lib/rubikon/action.rb                       | 9  |
	| lib/rubikon/application/base.rb             | 9  |
	| lib/rubikon/option.rb                       | 9  |
	| lib/rubikon/progress_bar.rb                 | 9  |
	| samples/helloworld.rb                       | 9  |
	+--------------------------------------------------+

And here is an example of taking the top 4 records on NChurn's git repo, output as xml report.

	$ NChurn -t 4 -r xml
	<?xml version="1.0" encoding="utf-8"?>
	<NChurnAnalysisResult xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
	  <FileChurns>
	    <FileChurn>
	      <File>README.md</File>
	      <Value>2</Value>
	    </FileChurn>
	    <FileChurn>
	      <File>.gitignore</File>
	      <Value>1</Value>
	    </FileChurn>
	    <FileChurn>
	      <File>AssemblyInfo.cs</File>
	      <Value>1</Value>
	    </FileChurn>
	    <FileChurn>
	      <File>Gemfile</File>
	      <Value>1</Value>
	    </FileChurn>
	  </FileChurns>
	</NChurnAnalysisResult>

Building
----------
You can build NChurn in 2 ways:

* Visual studio
* Rake (albacore)

To build with rake (the recommended way), make sure to `bundle install`, then look at your options with `rake -T`.  
_Note:_ I've excluded tf.log and tf.log.result from the repository, out of discreteness. Make sure to exclude from project or even better contribute back a log we can publicly use.

Contribute
----------

NChurn is an open-source project. Therefore you are free to help improving it.
There are several ways of contributing to NChurn's development:

* Build apps using NChurn and spread the word.
* Bug and features using the [issue tracker][2].
* Submit patches fixing bugs and implementing new functionality.
* Create an NChurn fork on [GitHub][1] and start hacking. Extra points for using GitHubs pull requests and feature branches.

License
-------

This code is free software; you can redistribute it and/or modify it under the
terms of the Apache License. See LICENSE.txt.

Copyright
---------

Copyright (c) 2011, Dotan Nahum <dotan@paracode.com>


[1]: http://github.com/jondot/nchurn
[2]: http://github.com/jondot/nchurn/issues
