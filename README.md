# Xecutioner #

Making it easy to run RSpec or Cucumber tests from MacVim in either Terminal or iTerm.

## Why?

While TDD'ing Rails apps, I find myself doing the same few actions over and over.

* Switch to iTerm
* Type in the command to execute the test (usually a specific test)
* Run command
* Switch back to MacVim making necessary changes
* Switch back to iTerm
* Arrow up to the previous command and run it
* Rinse and repeat until test and code are working and refactored

This is a serious pain point for me and what I consider a "Process Smell" because it ripe for
automation. Anytime there is a consistent set of tasks or actions that get repeated over and over like this,
it *should* be automated.

## Why Not Just Use Autotest

Good question. In many cases, it is the best option.

I am a big fan of running tests using Autotest, Guard, etc. but many times this is not the best solution for
the current application that is being built. A legacy system that has extremely slow tests is a good example
where you would not want to use an auto-tester. In an ideal world, you would re-write those tests to be more
performant but that is not an option in many cases.

## Usage

The best way I have found to use this script is to hook it up to a hot key.
When executed, it will provide you with a list of possible tests to run
from the focused buffer in MacVim.

There are many shortcut managers but the one I currently use is [Spark](http://www.macupdate.com/app/mac/14352/spark) and it is *free*.

Current setup - change the path to match where you put the files.
![Spark Setup](http://allancraig.net/personal/spark_setup.png "Spark Setup")

## iTerm or Terminal

The default setting is 'iTerm.'

*To use Terminal*

xecutioner.applescript
```applescript
  property EMULATOR : "Terminal"
```

## RSpec

RSpec files will list lines found that begin with the following:

* it
* describe
* context

## Cucumber

Cucumber files will list lines found that begin with the following:

* Scenario

## Choosing a Test

After entering key command and activating the script, you are presented with a list of
tests to choose from. Selecting one will run that specific test only. Choosing "Run'em All!"
will run the entire file.

Each successive execution will highlight the previously selected test for you making it a faster
process to run the test again. This is only saved for the current file.

![Choosing Available Tests](http://allancraig.net/personal/choose_from_tests.png)


# License #

BSD
