require 'redmine_tracker_accessible/tracker_accessible_role_patch'

Rails.configuration.to_prepare do
  Role.send(:include, TrackerAccessibleRolePatch)
end
