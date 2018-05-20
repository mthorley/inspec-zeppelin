control 'zeppelin_web_secure' do
  title 'Zeppelin must use web secure methods'
  impact 1.0

  describe zeppelin_site_config do
    it { should exist }
    its('xframe_options') { should cmp 'SAMEORIGIN' }
    its('xss_protection') { should be true }
    its('websocket_origin') { should_not be '*' }
    its('interpreters') { should_not include 'org.apache.zeppelin.shell.ShellInterpreter' }
  end

end
