module Rescuegroups
  class Client

    OPERATIONS = {  :eq => "equal",
                    :ne => "notequal",
                    :lt => "lessthan",
                    :lte => "lessthanorequal",
                    :gt => "greaterthan",
                    :gte => "greaterthanorequal",
                    :contains => "contains",
                    :notcontains => "notcontains",
                    :blank => "blank",
                    :notblank => "notblank",
                    :radius => "radius"}

    attr_accessor :api_key, :object_type, :object_action, :search, :fields, :token, :token_hash, :values

    def initialize(options={})
      self.api_key = options[:api_key] || Rescuegroups.api_key
      self.object_type = options[:object_type]
      self.object_action = options[:object_action]
      self.search = search_params
      self.values = value_params
      
      raise ArgumentError, "Please provide object_type and object_action" if (self.object_type == nil or self.object_action == nil)
    end

    def login(options={})
      main_options = { :username => options[:username],
                       :password => options[:password],
                       :account_number => options[:account_number],
                       :action => "login"}
      main_options = camelize(main_options)
      response_object = Curl.post(Rescuegroups::Configuration::ENDPOINT, main_options.to_json)
      response = JSON.parse(response_object.body_str)
      if response["status"] == "ok"
        self.token = response["data"]["token"]
        self.token_hash = response["data"]["tokenHash"]
        puts "Login successful. Token set as #{self.token} and token hash as #{self.token_hash}"
        return true
      else
        puts "Login unsuccessful." + response["messages"]["generalMessages"]["messageText"]
        return false
      end
    end  

    def logged_in?
      self.token && self.token_hash
    end

    def set_search_filter(field_name, operation, criteria)

      filter ={ :field_name => field_name.to_s.split("_").each_with_index {|part,i| part.capitalize! unless i == 0}.join,
                :operation => OPERATIONS[operation],
                :criteria => criteria.to_s}
      self.search["search"]["filters"] << camelize(filter)
    end

    def clear_search_filters
      self.search["search"]["filters"] = []
    end

    def set_search_fields(fields)
      self.search["search"]["fields"] = fields
    end

    def clear_search_fields
      self.search["search"]["fields"] = []
    end

    def set_value_fields(fields)
      self.values["values"] << camelize(fields)
    end

    def clear_value_fields
      self.values["values"] = []
    end

    def query
      response_object = Curl.post(Rescuegroups::Configuration::ENDPOINT, query_params.to_json)
      @response = JSON.parse(response_object.body_str)
    end

    def query_params
      if logged_in?
        main_options = {:token => self.token,
                        :token_hash => self.token_hash, 
                        :object_type => self.object_type,
                        :object_action => self.object_action}
      else
        main_options = {:apikey => self.api_key, 
                        :object_type => self.object_type,
                        :object_action => self.object_action}
      end

      if self.search["search"]["filters"].present?
        main_options.merge!(self.search)
      elsif self.values["values"].present?
        main_options.merge!(self.values)
      end
      main_options = camelize(main_options)
      return main_options
    end

    def search_params
      camelize({:search => 
        {
          :result_start => 0,
          :result_limit => 10,
          :result_sort => "animalID",
          :result_order => "asc",
          :fields => [],
          :filters => []
        }
      })
    end

    def value_params
      camelize({:values =>[] })
    end

    def camelize(snake_hash)
      camel_hash = {}
      snake_hash.each do |k,v|
        camelized_key = k.to_s.split("_").each_with_index do |part,i| 
          next if i == 0
          (part == "id")? part.upcase! : part.capitalize!
        end.join
        if v.class ==  Hash
          camel_hash[camelized_key] = camelize(v)
        else
         camel_hash[camelized_key] = v
        end
      end
      return camel_hash
    end

  end
end