describe package('UniversalForwarder') do
    it { should be_installed }
  end
  
describe service('SplunkForwarder') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end