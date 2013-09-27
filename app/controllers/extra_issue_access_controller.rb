class ExtraIssueAccessController < ApplicationController
  before_filter :find_project, :authorize, :only => [:new, :create, :destroy, :autocomplete_for_user]

  helper :extra_access
  include ExtraAccessHelper

  def new
    @users = users_for_extra_access.limit(100)
  end

  def create
    user_ids = []
    user_ids << params[:extra_access][:user_ids]

    user_ids.flatten.compact.uniq.each do |user_id|
      TrackerAccessibleIssuePermission.create(:issue => @issue, :user_id => user_id)
    end
    @users = users_for_extra_access.like(params[:q]).limit(100)
  end

  def destroy

    TrackerAccessibleIssuePermission.where(:issue_id => @issue, :user_id => params[:user_id]).destroy_all
  end

  def autocomplete_for_user
    @users = users_for_extra_access.like(params[:q]).limit(100)
    render :layout => false
  end

  private

    def find_project
      @issue = Issue.find(params[:issue_id])
      @project = @issue.project
    rescue
      render_404
    end

    def users_for_extra_access
      scope = @project.users.active.sorted
      if (already_accessed_ids = @issue.extra_access_users.map(&:id)).any?
        scope.where("#{User.table_name}.id NOT IN (?)", already_accessed_ids)
      else
        scope
      end
    end

end
