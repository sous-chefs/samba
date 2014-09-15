if defined? ChefSpec
  def create_samba_user(name)
    ChefSpec::Matchers::ResourceMatcher.new :samba_user, :create, name
  end
end
