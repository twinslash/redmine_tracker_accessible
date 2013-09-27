module ExtraAccessHelper

  # copy paste from WatchersHelper#watchers_list
  # Returns a comma separated list of users which have extra accessed to the issue
  def extra_accessed_list(issue)
    remove_allowed = User.current.allowed_to?(:tracker_accessible_extra_issue_access, issue.project)
    content = ''.html_safe
    lis = issue.extra_access_users.collect do |user|
      s = ''.html_safe
      s << avatar(user, :size => "16").to_s
      s << link_to_user(user, :class => 'user')
      if remove_allowed
        url = {:controller => 'extra_issue_access',
               :action => 'destroy',
               :issue_id => issue.id,
               :user_id => user.id}
        s << ' '
        s << link_to(image_tag('delete.png'), url,
                     :remote => true, :method => 'delete', :class => "delete")
      end
      content << content_tag('li', s, :class => "user-#{user.id}")
    end
    content.present? ? content_tag('ul', content, :class => 'extra-access') : content
  end

end
