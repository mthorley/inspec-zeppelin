
control 'zeppelin-01' do
  impact 1.0
  title 'Must use encryption in transit'
  desc 'Ensure TLS1.2 is enabled, with no renegotiation' 

  describe zeppelin_site_config do
    it { should exist }
    its('ssl_enabled') { should be true }
    its('enforce_https') { should be true }
  end

end

control 'zeppelin-02' do
  title 'Must use have authentication enabled'
  impact 1.0

  describe zeppelin_site_config do 
    it { should exist }
    its("anonymous_authentication") { should be false }
  end

end

control 'zeppelin-03' do
  title 'Must use web secure methods'
  impact 1.0

  describe zeppelin_site_config do
    it { should exist }
    its('xframe_options') { should cmp 'SAMEORIGIN' }
    its('xss_protection') { should be true }
    its('websocket_origin') { should_not be '*' }
    its('interpreters') { should_not include 'org.apache.zeppelin.shell.ShellInterpreter' }
  end

end
