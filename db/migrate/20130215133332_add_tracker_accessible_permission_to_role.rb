class AddTrackerAccessiblePermissionToRole < ActiveRecord::Migration
  def change
    add_column :roles, :tracker_accessible_permission, :string
  end
end
