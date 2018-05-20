control 'zeppelin_pam_authn' do
  title 'Zeppelin must use PAM and only PAM for authentication'
  impact 1.0

  describe zeppelin_shiro_config do
    it { should exist }
    its("pam_authentication_enabled") { should be true }
    its("authentication_methods_count") { skip }
  end

  describe zeppelin_site_config do 
    it { should exist }
    its("anonymous_authentication") { should be false }
  end

end
