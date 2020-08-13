# Sprint Manager Plugin Documentation

## Installation

* Copy sprint_manager plugin to {RAILS_APP}/plugins on your redmine path
* Run
```
bundle install --without development RAILS_ENV=production
bundle exec rake redmine:plugins NAME=sprint_manager RAILS_ENV=production
```

## Uninstall:

* Run
```
bundle exec rake redmine:plugins NAME=sprint_manager VERSION=0 RAILS_ENV=production
```
* Remove the plugin directory
```
rm -r plugins/sprint_manager
```
