module TrackerAccessibleIssuePatch
  def self.included(base)

    base.class_eval do
      has_many :tracker_accessible_issue_permissions, :dependent => :destroy
      has_many :extra_access_users, :through => :tracker_accessible_issue_permissions, :source => :user

      # ========= start patch visible_condition =========
      unless Issue.respond_to?(:visible_condition_block)
        # move logic for patching logic in separate method in order to avoid possible conflicts with another plugins

        # Returns a SQL conditions string used to find all issues visible by the specified user on it's index page
        def self.visible_condition(user, options={})
          Project.allowed_to_condition(user, :view_issues, options) do |role, user|
            visible_condition_block(role, user)
          end
        end

        # this is origin logic which is moved in separate method for patching purposes
        def self.visible_condition_block(role, user)
          if user.logged?
            case role.issues_visibility
            when 'all'
              nil
            when 'default'
              user_ids = [user.id] + user.groups.map(&:id)
              "(#{table_name}.is_private = #{connection.quoted_false} OR #{table_name}.author_id = #{user.id} OR #{table_name}.assigned_to_id IN (#{user_ids.join(',')}))"
            when 'own'
              user_ids = [user.id] + user.groups.map(&:id)
              "(#{table_name}.author_id = #{user.id} OR #{table_name}.assigned_to_id IN (#{user_ids.join(',')}))"
            else
              '1=0'
            end
          else
            "(#{table_name}.is_private = #{connection.quoted_false})"
          end
        end
      end

      # patch for visible_condition_block
      def self.visible_condition_block_with_tracker_accessible(role, user)
        if user.logged? && role.issues_visibility == 'issues_tracker_accessible'
          [tracker_conditions(role), owner_conditions(user), extra_access_conditions(user)].join(' OR ')
        else
          visible_condition_block_without_tracker_accessible(role, user)
        end
      end

      class << self
        # use alias_method_chain to have origin methods and patched ones.
        # it will help to patch origin logic in other places (=plugins)
        alias_method_chain :visible_condition_block, :tracker_accessible
      end
      # ========= end patch visible_condition =========

      # ========= start patch visible =========
      unless Issue.new.respond_to?(:visible_block)
        # move logic for patching logic in separate method in order to avoid possible conflicts with another plugins

        # Returns true if usr or current user is allowed to view the issue's show page
        def visible?(usr=nil)
          (usr || User.current).allowed_to?(:view_issues, self.project) do |role, user|
            visible_block(role, user)
          end
        end

        # this is origin logic which is moved in separate method for patching purposes
        def visible_block(role, user)
          if user.logged?
            case role.issues_visibility
            when 'all'
              true
            when 'default'
              !self.is_private? || (self.author == user || user.is_or_belongs_to?(assigned_to))
            when 'own'
              self.author == user || user.is_or_belongs_to?(assigned_to)
            else
              false
            end
          else
            !self.is_private?
          end
        end
      end

      # patch for visible_block
      def visible_block_with_tracker_accessible(role, user)
        if user.logged? && role.issues_visibility == 'issues_tracker_accessible'
          tracker_ids = role.issue_accessible_by_tracker_permission.map(&:to_i).delete_if(&:zero?)
          # build a condition
          tracker_ids.include?(tracker_id) || # issue in predefined (by role) trackers
            author == user || # user is author
            user.is_or_belongs_to?(assigned_to) || # user is assign_to issue
            watchers.map(&:user_id).include?(user.id) || # user is watcher
            extra_access_user_ids.include?(user.id) # user has extra access
        else
          visible_block_without_tracker_accessible(role, user)
        end
      end
      # use alias_method_chain to have origin methods and patched ones.
      # it will help to patch origin logic in other places (=plugins)
      alias_method_chain :visible_block, :tracker_accessible
      # ========= end patch visible =========

      private

        # user should see issues in predefined (by role) trackers
        def self.tracker_conditions(role)
          tracker_ids = role.issue_accessible_by_tracker_permission.map(&:to_i).delete_if(&:zero?)
          if tracker_ids.any?
            "(#{table_name}.tracker_id IN (#{tracker_ids.join(',')}))"
          else
            # no accessible trackers - no issue access (show nothing)
            "(#{table_name}.tracker_id is NULL)"
          end
        end

        # user should see issues if he is author or it is assigned to him
        def self.owner_conditions(user)
            user_ids = [user.id] + user.groups.map(&:id)
            "(#{table_name}.author_id = #{user.id} OR #{table_name}.assigned_to_id IN (#{user_ids.join(',')}))"
        end

        # user should see issues if he has an extra access
        def self.extra_access_conditions(user)
          if (extra_access_issue_ids = TrackerAccessibleIssuePermission.where(user_id: user).pluck(:issue_id)).any?
            "(#{table_name}.id IN (#{extra_access_issue_ids.join(',')}))"
          else
            '1=0'
          end
        end

    end

  end
end
