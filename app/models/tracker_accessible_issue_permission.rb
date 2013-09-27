class TrackerAccessibleIssuePermission < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
end
