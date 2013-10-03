require 'redmine_tracker_accessible'
require 'redmine'

# source: https://github.com/jbbarth/redmine_organizations - thanks!
# Little hack for deface in redmine:
# - redmine plugins are not railties nor engines, so deface overrides are not detected automatically
# - deface doesn't support direct loading anymore ; it unloads everything at boot so that reload in dev works
# - hack consists in adding "app/overrides" path of the plugin in Redmine's main #paths
Rails.application.paths["app/overrides"] ||= []
Rails.application.paths["app/overrides"] << File.expand_path("../app/overrides", __FILE__)

Redmine::Plugin.register :redmine_tracker_accessible do
  name        'Redmine Tracker Accessible plugin'
  author      '//Twinslash'
  description 'Plugin allows to set up trackers for roles'
  version     '0.0.2'
  url         'https://github.com/twinslash/redmine_tracker_accessible'
  author_url  'http://twinslash.com'

  project_module :issue_tracking do
    permission :tracker_accessible_extra_issue_access, { :extra_issue_access => [:new, :create, :destroy, :autocomplete_for_user] }
  end

end
