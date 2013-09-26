This is Ruby wrapper for Rescuegroups API
http://support.rescuegroups.org:8091/display/userguide/HTTP+API

## Installation
Add to your Gemfile
```ruby
gem 'rescuegroups'
```

## Usage

First setup your api key
```ruby
Rescuegroups.configure do |config|
  config.api_key = 'ABCD'
end
``` 
Then create a client anywhere with object_type and object_action attributes.
Your snake_case symbols are automatically camelcased within.
```ruby
client = Rescuegroups::Client.new :object_type => "animals", :object_action => "publicSearch"
```

If you wish to perform elevated actions like add or edit animal you will have to login.
```ruby
client.login(:username => "john", :password => "doe", :account_number => "0")
```
This will attach token and tokenHash to further requests

### Search procedure

Add filters. For example to search for an animal with animalID as 1234
```ruby
client.set_search_filter 'animalID', :eq, "1234"
client.set_search_filter 'animalStatus', :eq, "Available" # Not required but adviced
```

To clear all filters do
```ruby
client.clear_search_filters
```

Specify the fields you need as an array
```ruby
client.set_search_fields ['animalName', 'animalID', 'animalBreed']
```

To clear all fields do
```ruby
client.clear_search_fields
```

Then, run the query and get the json
```ruby  
response = client.query
```

### Add/Edit animal procedure
To add animal species(dog/cat/bird) and primary breed are compulsory
First create a client and login
```ruby
client = Rescuegroups::Client.new :object_type => "animals", :object_action => "add" # or "edit"
client.login(:username => "john", :password => "doe", :user_account => "0")
```

Then set the values of fields(snake_cased)
```ruby
client.set_value_fields(:animal_name => "Pepsi", :animal_species_id => "Dog", :animal_primary_breed_id => "123")
```

Send a query as usual and watch for response
```ruby  
response = client.query
```


For available object type and object actions refer to 
http://support.rescuegroups.org:8091/display/userguide/HTTP+API+object+definitions

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
