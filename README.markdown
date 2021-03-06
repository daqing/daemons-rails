# Intro

Daemons gem integration for Rails 5.

## Get started

    1. Add this gem to Gemfile:

        gem 'daemons-rails', github: 'daqing/daemons-rails'

    2. Install:

        $ bundle install


## Generator

    rails generate daemon <name>

Then insert your code in the lib/daemons/\<name\>.rb stub. All pids and logs will live in the normal log/ folder. This helps to make things Capistrano friendly.

## Control

Individual control script:

    ./lib/daemons/<name>_ctl [start|stop|restart|status]
    rails daemon:<name>[:(start|stop|restart|status)]

Examples:

    rails daemon:test - runs lib/daemons/test.rb not daemonized
    rails daemon:test:start - start daemon using lib/daemons/test_ctl start
    rails daemon:test:stop - stop daemon using lib/daemons/test_ctl stop
    rails daemon:test:restart - restart daemon using lib/daemons/test_ctl restart
    rails daemon:test:status - show running status for daemon using lib/daemons/test_ctl status

App-wide control script:

    ./lib/daemons/daemons [start|stop|restart|status]
    rails daemons:(start|stop|status)

## Monitoring API

    Daemons::Rails::Monitoring.statuses - hash with all daemons and corresponding statuses
    Daemons::Rails::Monitoring.start("test.rb") - start daemon using lib/daemons/test_ctl start
    Daemons::Rails::Monitoring.stop("test.rb") - start daemon using lib/daemons/test_ctl stop
    Daemons::Rails::Monitoring.controllers - list of controllers
    Daemons::Rails::Monitoring.controller("test.rb") - controller for test.rb application

    controller = Daemons::Rails::Monitoring.controller("test.rb")
    controller.path # => lib/daemons/test_ctl
    controller.app_name # => test.rb
    controller.start # => starts daemon
    controller.stop # => stops daemon
    controller.status # => :not_exists or :running

## Configuration

You can set default settings for your daemons into config/daemons.yml file. Full list of options you can get from documentation to Daemons.daemonize method (http://daemons.rubyforge.org/classes/Daemons.html#M000007). Also it possible to set individual daemon options using file config/\<daemon_name\>-daemon.yml.
If you want to use directory other than default lib/daemons then you should add to application initialization block following lines:

    class MyApp < Rails::Application
        ...
        Daemons::Rails.configure do |c|
            c.daemons_path = Rails.root.join("new_daemons_path")
        end
        ...
    end

If you change your mind, you can easily move content of this directory to other place and change config.
Notice: this feature available only from version 1.1 and old generated daemons can't be free moved, because uses hard-coded path to lib/daemons. So, you can generate daemons with same names and then move client code to generated templates.

## Using multiple daemons set

At this moment it is not supported at generators and rails tasks levels, but you can generate daemon to default location and move to different folder (you should also copy *daemons* script to same directory). Then you will be able to operate with them using following scripts:

    other/daemons/location/daemons [start|stop|restart|status]
    other/daemons/location/<daemon_name>_ctl [start|stop|restart|status]

To access the daemons with Monitoring API you can use configured instance of *Daemons::Rails::Monitoring*:

    Daemons::Rails::Monitoring.new("other/daemons/location")

and same set of methods. Effectively, *Daemons::Rails::Monitoring* just delegates all method calls to *Daemons::Rails::Monitoring.default* initialized with configured daemons path.

# Changes

* 1.2.1 - add `rails daemon:<name>:restart` command
* 1.2.0 - development dependency on Rails bumped to support Rails 4 (dmilisic). Removed direct dependency on Daemons gem from generated files (in preparation for more daemonization providers)
* 1.1.2 - fix script template to load environment within Rails.root directory. It takes no effect on already generated scripts.
* 1.1.1 - fix dependencies, clean-up specs
* 1.1.0 - supported custom directory for daemons, support multiple daemons directories
* 1.0.0 - changed api for Daemons::Rails::Monitoring, fixed path in template for script, improved documentation, added RSpec
* 0.0.3 - added rails for running script without daemonization (rails daemon:\<name\>)

# License

You are free to choose kind of license to use:
[MIT License](http://www.opensource.org/licenses/MIT) or [GPL-2 License](http://www.gnu.org/licenses/gpl-2.0.html)
