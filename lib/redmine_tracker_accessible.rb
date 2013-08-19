require_dependency 'redmine_tracker_accessible/hooks'

require 'redmine_tracker_accessible/tracker_accessible_role_patch'
require 'redmine_tracker_accessible/tracker_accessible_issue_patch'
require 'redmine_tracker_accessible/issues_controller_patch'

Rails.configuration.to_prepare do
  Role.send(:include, TrackerAccessibleRolePatch)
  Issue.send(:include, TrackerAccessibleIssuePatch)
  IssuesController.send(:include, RedmineTrackerAccessible::IssuesControllerPatch)
end
