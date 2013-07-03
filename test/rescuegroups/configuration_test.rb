require 'helper'

describe 'configuration'  do

  describe '.api_key' do
    it 'should have an api key' do
      Rescuegroups.api_key.must_equal Rescuegroups::Configuration::API_KEY
    end
  end

  after do 
    Rescuegroups.reset    
  end

  describe '.configure' do
    it 'should configure api_key' do
      Rescuegroups.configure do |config|
        config.send("api_key=", "123")
        Rescuegroups.send("api_key").must_equal "123"
      end
    end
  end

end