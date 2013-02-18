module RedmineTrackerAccessible
  module IssuesControllerPatch

    def self.included(base)
      base.class_eval do
        unloadable

        before_filter :redmine_tracker_accessible_trackers_patch, :only => [:new, :create]

        private

        # build possible trackers for issue.
        # Possible trackers for user are:
        # predefined trackers by admin in "Roles and Permissions" + current issue's tracker (it allows user update issue and leave current tracker)
        # or
        # all trackers if this permission is not set up
        def redmine_tracker_accessible_trackers_patch
          # join trackers from permissions
          tracker_ids = User.current.roles_for_project(@project).map(&:tracker_accessible_permission).flatten.uniq
          # add issue's tracker
          tracker_ids << @issue.tracker_id if @issue.tracker
          # find trackers by ids or use all trackers (if permission is not set up)
          @issue.project.trackers = if tracker_ids.any?
            Tracker.where(:id => tracker_ids)
          else
            Tracker.scoped
          end
        end

      end
    end
  end
end
