# CancanStrongParameters

CanCan and [strong_parameters](https://github.com/rails/strong_parameters) are friends now!

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
