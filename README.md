# PISEC

Write your secure settings in environment variable that are formatted in a Platform Independent format (JSON) that can be used to configure your software

## Installation

Add this line to your application's Gemfile:

    gem 'pisec'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pisec

## Usage

configure it:
  vi config/secure_settings.sh:
  # The format for this file is essentially:
  # export <NAMESPACE>_<UPPERCASE_KEY_NAME>={<lowercase_key_name> => <val>}.to_json
  # e.g.
  export PISEC_DEV_DB_USER="{\"dev_db_user\":\"pisec\"}"

Rails:
initialize it:
  vi config/initializers/pisec.rb:
    Settings = Pisec::Support.load_file(
     "#{RAILS_ROOT}/config/secure_settings.sh", # data-file
     "PISEC" # namespace
    )

use it:
  Settings.get("dev_db_user")

Shell:
  #            config-file   namespace lookup-key
  ./bin/pisec -c README.md  -n PISEC  -l dev_db_user

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
