class AddIssueAccessibleByTrackerPermissionToRole < ActiveRecord::Migration
  def change
    add_column :roles, :issue_accessible_by_tracker_permission, :string
  end
end
