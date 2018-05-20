control 'zeppelin_enc_in_transit' do
  title 'Zeppelin must use encryption in transit'
  impact 1.0

  describe zeppelin_site_config do
    it { should exist }
    its('ssl_enabled') { should be true }
    its('enforce_https') { should be true }
  end

end
