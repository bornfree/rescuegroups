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

    attr_accessor :api_key, :object_type, :object_action, :search, :fields

    def initialize(options={})
      self.api_key = options[:api_key] || Rescuegroups.api_key
      self.object_type = options[:object_type]
      self.object_action = options[:object_action]
      self.search = camelize({:search => 
                      {
                        :result_start => 0,
                        :result_limit => 10,
                        :result_sort => "animalID",
                        :result_order => "asc",
                        :fields => [],
                        :filters => []
                      }
                    })

      raise ArgumentError, "Please provide object_type and object_action" if (self.object_type == nil or self.object_action == nil)
    end

    def filter(field_name, operation, criteria)

      filter ={ :field_name => field_name.to_s.split("_").each_with_index {|part,i| part.capitalize! unless i == 0}.join,
                :operation => OPERATIONS[operation],
                :criteria => criteria.to_s}
      self.search["search"]["filters"] << camelize(filter)
    end

    def fields(fields)
      self.search["search"]["fields"] = fields
    end

    def query
      response_object = Curl.post(Rescuegroups::Configuration::ENDPOINT, query_params.to_json)
      @response = JSON.parse(response_object.body_str)
    end

    def query_params
      main_options = {:apikey => self.api_key, 
                      :object_type => self.object_type,
                      :object_action => self.object_action}

      unless self.search["search"]["filters"].empty?
        main_options.merge!(self.search)
      end
      main_options = camelize(main_options)
      return main_options
    end

    def camelize(snake_hash)
      camel_hash = {}
      snake_hash.each do |k,v|
        camelized_key = k.to_s.split("_").each_with_index {|part,i| part.capitalize! unless i == 0}.join
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