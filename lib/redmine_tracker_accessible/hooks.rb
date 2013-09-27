module RedmineTrackerAccessible
  class Hooks < Redmine::Hook::ViewListener

    include IssuesControllerPatch::InstanceMethods

    def view_issues_form_details_top(context={})
      @issue = context[:issue]
      @project = context[:project]
      tracker_ids = tracker_accessible_allowed_tracker_ids
      @allowed_trackers = Tracker.where(:id => tracker_ids).order("#{Tracker.table_name}.position")

      "<script type='text/javascript'>
        $('select#issue_tracker_id').ready(function() {
          $('select#issue_tracker_id').html('#{escape_javascript(options_for_select(@allowed_trackers.collect { |t| [t.name, t.id] }, @issue.tracker_id))}');
        })
      </script>"
    end

    def view_layouts_base_html_head(context={})
      if context[:controller] && (context[:controller].is_a?(IssuesController))
        stylesheet_link_tag("tracker_accessible.css", :plugin => "redmine_tracker_accessible", :media => "screen")
      else
        ''
      end
    end

    def view_issues_sidebar_queries_bottom(context={})
      @issue = context[:issue]
      @project = context[:project]

      context[:controller].send(:render, { :partial => "extra_issue_access/siderbar_for_extra_access" })
    end

  end

end
