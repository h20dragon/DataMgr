# DataMgr

Data manager that provides support for JSON, YAML, and Database (e.g .SQL Server) dataware.  Provides
the ability to manage the state of your data - creation, retrieve, and execute (SQL), then manage
those results for re-use later .. in your automation framework, app. code, etc.

Put your Ruby code in the file `lib/DataMgr`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

### Prerequisite

http://stackoverflow.com/questions/33102569/installing-tiny-tds-gives-error-on-on-mac-os-10-10-5

Add this line to your application's Gemfile:

```ruby
gem 'DataMgr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install DataMgr

## Usage

### Creating a connection configuration YAML file

        MyConnectID:
          user: sasquatch
          password: kale
          host: somewhere-in-the-woods.com
          port: 2080
          description: Big Foot
        ---
        AnotherConnectID:
          user: bigbird
          password: yellow
          host: sesame-street
          port: 2080
          description: Sesame Street Gang

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/h20dragon/DataMgr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

