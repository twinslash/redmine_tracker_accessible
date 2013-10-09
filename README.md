# Redmine tracker accessible

This plugin limits available trackers for the role and gives access to the issues, as well as gives special access to the issue.


## Installation

Clone the code of the plugin to the folder REDMINE/plugins. Run the migrations.

```bash
cd REDMINE/plugins
git clone https://github.com/twinslash/redmine_tracker_accessible.git
bundle exec rake redmine:plugins:migrate NAME=redmine_tracker_accessible
```
Restart your server.


## Uninstall

Rollback migrations. Remove the plugin.
```bash
cd REDMINE/plugins
bundle exec rake redmine:plugins:migrate NAME=redmine_tracker_accessible VERSION=0
rm -rf redmine_tracker_accessible
```
Restart your server.


## Functionality

### Accessible trackers
A new multiselect box with all trackers will appear on the page "Administration/Roles and permissions" after installing the plugin. Setup the trackers for the role or indicate that all trackers will be accessible (default behavior).

![Role settings](https://raw.github.com/twinslash/redmine_tracker_accessible/master/images/role_settings_eng.png)

While creating a new issue, the user will have access only to those trackers that you have indicated. If the issue is being edited, then the user will have access only to the indicated trackers and current tracker.

### Visibility based on trackers
The plugin adds a new value `Issues with accessible trackers` to select "Issues visibility". Selecting it, you’ll get additional multiselect box with current trackers. Indicate the trackers you want to give access to.


### Special access
A new permission `Manage of extra issue access` will appear on the page "Administration/Roles and permissions" after installing the plugin. The role with this permission will manage of extra access to the issue. To perform this you’ll have to open the issue, open the block "Extra access to issue" in the right part of the page - and add a user to the project.

![Extra access](https://raw.github.com/twinslash/redmine_tracker_accessible/master/images/extra_access_eng.png)

The user with extra access will manage to open the issue and will get notifications about changes made in the issue according to his account settings.
