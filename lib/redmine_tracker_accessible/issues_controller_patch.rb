module RedmineTrackerAccessible
  module IssuesControllerPatch

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        before_filter :tracker_accessible_check_tracker_id, :only => [:new, :create, :update]
        alias_method_chain :build_new_issue_from_params, :tracker_accessible

        helper :extra_access
        include ExtraAccessHelper

      end
    end

    module InstanceMethods

      # nullify tracker_id if it is not allowed
      def tracker_accessible_check_tracker_id
        tracker_ids = tracker_accessible_allowed_tracker_ids
        if @issue.tracker_id_changed? && tracker_ids.exclude?(@issue.tracker_id)
          @issue.tracker_id = nil
        end
      end

      # build possible trackers for issue.
      # Possible trackers for user are:
      # predefined trackers by admin in "Roles and Permissions" + current issue's tracker (it allows user update issue and leave current tracker)
      def tracker_accessible_allowed_tracker_ids
        # join trackers from permissions
        tracker_ids = get_tracker_ids

        # add current issue's tracker if issue exists and tracker_ids contains smth
        tracker_ids << @issue.tracker_id_was if @issue.persisted? && tracker_ids.any?
        tracker_ids
      end

      # default params[:tracker_id] is taken from project settings @project.trackers.first
      # fields (defined by permissions) to display on the form are based on this value
      # predefine params[:tracker_id] with value according plugin settings
      def build_new_issue_from_params_with_tracker_accessible
        params[:tracker_id] ||= get_tracker_ids.first
        build_new_issue_from_params_without_tracker_accessible
      end

      private

        # join trackers from permissions
        def get_tracker_ids
          # all possible trackers for this project
          tracker_all = @project.trackers.pluck(:id)

          @tracker_ids = User.current.roles_for_project(@project).map do |role|
            if role.allow_all_trackers_permission?
              # use all trackers if flag is enabled
              tracker_all
            else
              ids = role.tracker_accessible_permission.map(&:to_i).delete_if(&:zero?)
              # use intersection ids and tracker_all
              ids & tracker_all
            end
          end
          @tracker_ids.flatten.uniq
        end

    end
  end
end
