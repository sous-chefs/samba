if defined? ChefSpec
  def create_samba_user(name)
    ChefSpec::Matchers::ResourceMatcher.new :samba_user, :create, name
  end

  def enable_samba_user(name)
    ChefSpec::Matchers::ResourceMatcher.new :samba_user, :enable, name
  end

  def delete_samba_user(name)
    ChefSpec::Matchers::ResourceMatcher.new :samba_user, :delete, name
  end
end
