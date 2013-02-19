# Redmine tracker accessible

Plugin allows to setup trackers for roles. User can create new issues only in selected trackers.

## Install

Clone code of the plugin to folder REDMINE/plugins and run migrations
```bash
cd REDMINE/plugins
git clone https://github.com/twinslash/redmine_tracker_accessible.git
bundle exec rake redmine:plugins:migrate NAME=redmine_tracker_accessible
```
Restart your Redmine


## Uninstall

Revert migrations. Remove plugin code.
```bash
cd REDMINE/plugins
bundle exec rake redmine:plugins:migrate NAME=redmine_tracker_accessible VERSION=0
rm redmine_tracker_accessible -rf
```
Restart your Redmine


## Usage

A new multiselect box will appear on page "Administration/Roles and permisions" after installing the plugin. This box contains all trackers. Setup them for each role.

When user creates a new issue only selected trackers will be displayed. If user updates existed issue then selected trackers plus current issue tracker will be accessible. If no trackers is setup for role then all trackers will be accessible.
