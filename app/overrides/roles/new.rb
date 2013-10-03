Deface::Override.new(
  :virtual_path => "roles/new",
  :name => "tracker_accessible_roles_new",
  :insert_after => 'h2',
  :partial => 'roles/tracker_accessible_permission_select_js',
  :disabled => false)
