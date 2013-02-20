module RedmineTrackerAccessible
  module IssuesControllerPatch

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do

        before_filter :tracker_accessible_check_tracker_id, :only => [:create, :update]

      end
    end

    module InstanceMethods

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
      # all trackers for this project if this permission is not set up
      def tracker_accessible_allowed_tracker_ids
        # all possible trackers for this project
        tracker_all = @project.trackers.pluck(:id)
        # join trackers from permissions
        tracker_ids = User.current.roles_for_project(@project).map do |role|
          ids = role.tracker_accessible_permission.map(&:to_i).delete_if(&:zero?)
          # if ids is empty it seems that Permission is not set up - use all trackers
          # if ids then take intersection with tracker_all
          ids.any? ? ids & tracker_all : tracker_all
        end

        tracker_ids = tracker_ids.flatten.uniq
        # add current issue's tracker if issue exists and tracker_ids contains smth
        tracker_ids << @issue.tracker_id_was if @issue.persisted? && tracker_ids.any?
        tracker_ids
      end

    end
  end
end
