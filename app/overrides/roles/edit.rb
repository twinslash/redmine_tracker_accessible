Deface::Override.new(
  :virtual_path => "roles/edit",
  :name => "tracker_accessible_roles_edit",
  :insert_after => 'erb[silent]',
  :partial => 'roles/tracker_accessible_permission_select_js',
  :disabled => false)