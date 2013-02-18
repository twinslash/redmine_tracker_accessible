module TrackerAccessibleRolePatch
  def self.included(base)
    base.class_eval do
      unloadable

      serialize :tracker_accessible_permission, Array

    end
  end
end
