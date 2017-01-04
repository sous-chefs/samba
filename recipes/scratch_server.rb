users = if node['samba']['passdb_backend'] != ~ /^ldapsam/ && node['samba']['enable_users_search']
          search(node['samba']['users_data_bag'], '*:*') # ~FC003
        end

if users
  users.each do |u|
    next unless u['smbpasswd']
    samba_user u['id'] do
      password u['smbpasswd']
      action [:create, :enable]
    end
  end
end
