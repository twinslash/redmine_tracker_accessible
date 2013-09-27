require 'redmine_tracker_accessible'

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
