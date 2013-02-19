module RedmineTrackerAccessible
  module IssuesControllerPatch

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do

        before_filter :tracker_accessible_check_tracker_id, :only => [:create, :update]
        before_filter :tracker_accessible_build_allowed_trackers, :only => [:new, :create, :show, :edit]

      end
    end

    module InstanceMethods

      # define @issue.project.trackers according to settings
      def tracker_accessible_build_allowed_trackers
        tracker_ids = tracker_accessible_allowed_tracker_ids
        # find trackers by ids or use all trackers (if permission is not set up)
        @issue.project.trackers = if tracker_ids.any?
          Tracker.where(:id => tracker_ids).order("#{Tracker.table_name}.position")
        else
          Tracker.scoped
        end
      end

      # nullify tracker_id if it is not allowed
      def tracker_accessible_check_tracker_id
        tracker_ids = tracker_accessible_allowed_tracker_ids
        if tracker_ids.exclude?(@issue.tracker_id)
          @issue.tracker_id = nil
        end
      end

      # build possible trackers for issue.
      # Possible trackers for user are:
      # predefined trackers by admin in "Roles and Permissions" + current issue's tracker (it allows user update issue and leave current tracker)
      # or
      # all trackers if this permission is not set up
      def tracker_accessible_allowed_tracker_ids
        # join trackers from permissions
        tracker_ids = User.current.roles_for_project(@project).map(&:tracker_accessible_permission)
        tracker_ids = tracker_ids.flatten.delete_if(&:blank?).uniq
        # add current issue's tracker if issue exists and tracker_ids contains smth
        # if tracker_ids is empty it seems that Permission is not set up and Tracker.scoped will be used
        tracker_ids << @issue.tracker_id_was if @issue.persisted? && tracker_ids.any?
        tracker_ids
      end

    end
  end
end
