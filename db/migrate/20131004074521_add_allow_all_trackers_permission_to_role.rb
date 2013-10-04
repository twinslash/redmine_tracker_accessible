class AddAllowAllTrackersPermissionToRole < ActiveRecord::Migration
  def change
    add_column :roles, :allow_all_trackers_permission, :boolean, default: true
  end
end
