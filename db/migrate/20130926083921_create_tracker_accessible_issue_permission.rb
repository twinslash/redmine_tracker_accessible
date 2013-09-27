class CreateTrackerAccessibleIssuePermission < ActiveRecord::Migration
  def change
    create_table :tracker_accessible_issue_permissions do |t|
      t.integer :issue_id
      t.integer :user_id

      t.timestamps
    end
  end
end
