# workshop-portal

A Ruby on Rails app to manage workshops

Branch | Travis CI  | Code Analysis | Heroku Deploy | Errbit | NewRelic
------ | ---------- | ------------- | ------------- | ------ | --------
master  | [![Build Status](https://travis-ci.org/hpi-swt2/workshop-portal.svg?branch=master)](https://travis-ci.org/hpi-swt2/workshop-portal) | [![Coverage Status](https://coveralls.io/repos/github/hpi-swt2/workshop-portal/badge.svg?branch=master)](https://coveralls.io/github/hpi-swt2/workshop-portal?branch=master) [![Code Climate](https://codeclimate.com/github/hpi-swt2/workshop-portal/badges/gpa.svg)](https://codeclimate.com/github/hpi-swt2/workshop-portal/issues) | [![Heroku](https://heroku-badge.herokuapp.com/?app=workshop-portal)](http://workshop-portal.herokuapp.com/) [[link]](http://workshop-portal.herokuapp.com/) | [[link]](http://swt2-errbit-2016.herokuapp.com/) | [[link]](https://rpm.newrelic.com/accounts/1114162/applications/27552951) (login: hpi.swt2@gmail.com <br> pw: swt2workshops!) |
dev  | [![Build Status](https://travis-ci.org/hpi-swt2/workshop-portal.svg?branch=dev)](https://travis-ci.org/hpi-swt2/workshop-portal) | [![Coverage Status](https://coveralls.io/repos/github/hpi-swt2/workshop-portal/badge.svg?branch=dev)](https://coveralls.io/github/hpi-swt2/workshop-portal?branch=dev) | [![Heroku](https://heroku-badge.herokuapp.com/?app=workshop-portal-dev)](http://workshop-portal-dev.herokuapp.com/) [[link]](http://workshop-portal-dev.herokuapp.com/) |

When all tests succeed on Travis CI, the application is deployed to Heroku. Click the badges for detailed info.
Errors that occur while using the deployed master branch on Heroku are logged to the [Errbit](http://swt2-errbit-2016.herokuapp.com/) error catcher, you can sign in with your Github account.

## Local Setup

* `bundle install` Install the required Ruby gem dependencies defined in the [Gemfile](https://github.com/hpi-swt2/workshop-portal/blob/master/Gemfile)
* `cp database.sqlite.yml database.yml` Select database config (for development we recommend SQLite) 
* `rake db:create db:migrate db:seed` Setup database, run migrations, seed the database with defaults
* `rails s` Start the Rails development server (By default runs on _localhost:3000_)
* `rspec` Run all the tests (using the [RSpec](http://rspec.info/) test framework)

## Setup using Vagrant (Virtual Machine)

If you want to use a VM to setup the project (e.g. when on Windows), we recommend [Vagrant](https://www.vagrantup.com/).
Please keep in mind that this method may lead to a loss in performance, due to the added abstraction layer.

```
vagrant up # bring up the VM
vagrant ssh # login using SSH
cd hpi-swt2
echo "gem: --no-document" >> ~/.gemrc # disable docs for gems
bundle install # install dependencies
gem install pg # required for Postgres usage
cp config/database.psql.yml config/database.yml # in case you want to use Postgres
cp config/database.sqlite.yml config/database.yml # in case you want to user SQLite
exit # restart the session, required step
vagrant ssh # reconnect to the VM
cd hpi-swt2
rails s -b 0 # start the rails server
# the -b part is necessary since the app is running in a VM and would
# otherwise drop the requests coming from the host OS
```

## Important Development Commands
* `bundle exec <command>` Run command within the context of the current gemset
* `rspec spec/controller/expenses_controller_spec.rb` Specify a folder or test file to run
* `rails c` Run the Rails console
* `rails c --sandbox` Test out some code without changing any data
* `rails g migration DoSomething` Create migration _db/migrate/*_DoSomething.rb_.
* `rails dbconsole` Starts the CLI of the database you're using
* `rake routes` Show all the routes (and their names) of the application
* `rails assets:precompile` Precompile the assets in app/assets to public/assets
* `rake about` Show stats on current Rails installation, including version numbers
* `rspec --profile` examine how much time individual tests take
