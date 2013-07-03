module Rescuegroups
  module Configuration

    ENDPOINT     = 'https://api.rescuegroups.org/http/json'
    API_KEY      = nil
    CONTENT_TYPE = "application/json"

    attr_accessor :api_key

    def self.extended(base)
      base.reset
    end
 
    def reset
      self.api_key = API_KEY
    end

    def configure
      yield self
    end
    
  end
end