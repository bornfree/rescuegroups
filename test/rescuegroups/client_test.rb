require 'helper'

describe 'client' do 

  describe '.api_key' do
    it 'should be able to set api key when provided' do
      client = Rescuegroups::Client.new :api_key => "123", :object_type => "animals", :object_action => "define"
      client.api_key.must_equal "123"
    end

    it 'should be able to revert to default when api key when created' do
      client = Rescuegroups::Client.new :object_type => "animals", :object_action => "define"
      client.api_key.must_equal Rescuegroups::Configuration::API_KEY
    end

    it 'should have all three values of apikey, objecttype and objectaction' do
      client = Rescuegroups::Client.new :object_type => "animals", :object_action => "define"
    end

    it 'should run a query and return something' do
      client = Rescuegroups::Client.new :object_type => "animals", :object_action => "define"
      client.filter :age, :lt, 5
      client.query != nil
    end 

end

end