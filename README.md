# workshop-portal

[![Code Climate](https://codeclimate.com/github/hpi-swt2/workshop-portal/badges/gpa.svg)](https://codeclimate.com/github/hpi-swt2/workshop-portal)
[![Test Coverage](https://codeclimate.com/github/hpi-swt2/workshop-portal/badges/coverage.svg)](https://codeclimate.com/github/hpi-swt2/workshop-portal/coverage)
[![Build Status](https://travis-ci.org/hpi-swt2/workshop-portal.svg?branch=dev)](https://travis-ci.org/hpi-swt2/workshop-portal)
[![Heroku](https://heroku-badge.herokuapp.com/?app=workshop-portal)](http://workshop-portal.herokuapp.com/)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/hpi-swt2/workshop-portal/blob/master/LICENSE)

## Building Status

Branch      | Status
----------- | ----------
master  | [![Build Status](https://travis-ci.org/hpi-swt2/workshop-portal.svg?branch=master)](https://travis-ci.org/hpi-swt2/wprkshop-portal)
dev  | [![Build Status](https://travis-ci.org/hpi-swt2/workshop-portal.svg?branch=dev)](https://travis-ci.org/hpi-swt2/workshop-portal)

## Heroku Deployment

When TravisCI run all tests successfully, the build is deployed to heroku. This is done for the master branch as well as the dev branch.

Branch      | Heroku App | Status
----------- | ---------- | ----------
master  |  [click here](http://workshop-portal.herokuapp.com/)  | [![Heroku](https://heroku-badge.herokuapp.com/?app=workshop-portal)](http://workshop-portal.herokuapp.com/)
dev  |  [click here](http://workshop-portal-dev.herokuapp.com/)  | [![Heroku](https://heroku-badge.herokuapp.com/?app=workshop-portal-dev)](http://workshop-portal-dev.herokuapp.com/)

## Setup

Install gem bundle with

```bundle install```

select database config (in this case we take the sqlite)

```cp database.sqlite.yml database.yml```

create a database, run the available migrations and seed the database with mandatory default values

```rake db:create db:migrate db:seed```

then we can run either the rails console with

```rails c```

or the rails server with

```rails s```

in case you want to run all tests go ahead and execute

```rspec ```

or by specifing the exact spec file with

```rspec spec/controller/expenses_controller_spec.rb```

## Vagrant

In case you want to setup this project via windows, you may want to use vagrant like described in the following. Please keep in mind, that vagrant will be slower since it is handled via VM.

```
vagrant up
vagrant ssh
cd hpi-swt2
# disable docs for gems
echo “gem: --no-document” >> ~/.gemrc
bundle install
gem install pg
cp config/database.psql.yml config/database.yml
# restarting the session
exit
```

in case you want to use sqlite

```
bundle install --without=production
cp config/database.sqlite.yml config/database.yml
```

And finally starting the server with

```
vagrant ssh #connect with VM
cd hpi-swt2
rails s -b 0 #starting rails server, the -b part is necessary since the app is running in a VM and would otherwise drop the requests coming from the host OS
```

## Debugging

### Errbit
```
http://swt2-2016-errbit.herokuapp.com/
```

Please request a login from @chrisma or @derari

### NewRelic
```
http://newrelic.com/
