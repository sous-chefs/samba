if platform_family?('rhel', 'fedora', 'suse', 'amazon')
  package 'samba-client'
else
  package 'smbclient'
end
