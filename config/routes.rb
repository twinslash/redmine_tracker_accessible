get 'extra_issue_access/new', :to => 'extra_issue_access#new'
post 'extra_issue_access', :to => 'extra_issue_access#create'
delete 'extra_issue_access', :to => 'extra_issue_access#destroy'
get 'extra_issue_access/autocomplete_for_user', :to => 'extra_issue_access#autocomplete_for_user'
