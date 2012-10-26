# CancanStrongParameters

CanCan and [strong_parameters](https://github.com/rails/strong_parameters) are friends now!

[![Build Status](https://secure.travis-ci.org/colinyoung/cancan_strong_parameters.png)](http://travis-ci.org/colinyoung/cancan_strong_parameters)

## Authors

The majority of this gem is credited to @mckeed, who posted this gist: https://gist.github.com/2878508
I (@colinyoung) helped put some of it together.


## Installation

Add this line to your application's Gemfile:

    gem 'cancan_strong_parameters'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cancan_strong_parameters

## Usage

    1. Add it to your Gemfile
    2. Wherever you use `load_and_authorize_resource`, also add:
    
        class PostsController < ApplicationController
          ...
          load_and_authorize_resource
          permit_params post: [:name, :title, author: {:name}]
        end
        
## Testing

Run with `bundle exec rake test`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog

* Fixed some issues with nested form subfields in `permit_params`
* Made compatible for nested forms
* Added default allows for _destroy.
* Tests pass in Travis.
* Fixes for irregular parameters posted like {"child_attributes" => {"0" => {}}}.