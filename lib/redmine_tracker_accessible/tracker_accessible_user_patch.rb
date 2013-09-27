module TrackerAccessibleUserPatch

  def self.included(base)
    base.class_eval do
      has_many :tracker_accessible_issue_permissions, :dependent => :destroy
      has_many :extra_access_issues, :through => :tracker_accessible_issue_permissions, :source => :issue
    end
  end

end
