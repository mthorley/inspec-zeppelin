control 'zeppelin-pam-authN' do
  title 'Must use PAM and only PAM for authentication'
  impact 1.0

  describe zeppelin_shiro_config do
    it { should exist }
    its("pam_authentication_enabled") { should be true }
    its("authentication_methods_count") { skip }
  end

end
