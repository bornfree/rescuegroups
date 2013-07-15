This is Ruby wrapper for Rescuegroups API
http://support.rescuegroups.org:8091/display/userguide/HTTP+API

For now, as gem is not yet complete, please clone/fork the repo
and bundle using the :path param in your Gemfile.

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
Add filters. For example to search for an animal with animalID as 1234
```ruby
client.filter 'animalID', :eq, "1234"
client.filter 'animalStatus', :eq, "Available" # Not required but adviced
```
Specify what filters you need as an array
```ruby
client.fields ['animalName', 'animalID', 'animalBreed']
```
Run the query and get the json
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
