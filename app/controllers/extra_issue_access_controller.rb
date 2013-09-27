class ExtraIssueAccessController < ApplicationController
  before_filter :find_project, :authorize, :only => [:new, :create, :destroy, :autocomplete_for_user]

  helper :extra_access
  include ExtraAccessHelper

  def new
    @users = @project.users.where("#{User.table_name}.id NOT IN (?)", @issue.extra_access_users.map(&:id)).active.sorted.limit(100)
  end

  def create
    user_ids = []
    user_ids << params[:extra_access][:user_ids]

    user_ids.flatten.compact.uniq.each do |user_id|
      TrackerAccessibleIssuePermission.create(:issue => @issue, :user_id => user_id)
    end
    @users = @project.users.active.sorted.where("#{User.table_name}.id NOT IN (?)", @issue.extra_access_users.map(&:id)).like(params[:q]).limit(100)
  end

  def destroy

    TrackerAccessibleIssuePermission.where(:issue_id => @issue, :user_id => params[:user_id]).destroy_all
  end

  def autocomplete_for_user
    @users = @project.users.active.sorted.where("#{User.table_name}.id NOT IN (?)", @issue.extra_access_users.map(&:id)).like(params[:q]).limit(100)
    render :layout => false
  end

  private

    def find_project
      @issue = Issue.find(params[:issue_id])
      @project = @issue.project
    rescue
      render_404
    end

end
