execute 'apt-get update' if platform_family?('debian')

include_recipe 'samba::client'
