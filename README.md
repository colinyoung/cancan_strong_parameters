# CancanStrongParameters

[strong_parameters](rails/strong_parameters) and [CanCan](ryanb/cancan) (and others, like ActiveAdmin) are friends now!

This gem makes it easy to control the authorization of params used by CanCan.

[![Build Status](https://secure.travis-ci.org/colinyoung/cancan_strong_parameters.png)](http://travis-ci.org/colinyoung/cancan_strong_parameters)

## Authors

The majority of this gem is credited to @mckeed, who posted this gist: https://gist.github.com/2878508. I (@colinyoung) helped put some of it together.

## Installation

Add this line to your application's Gemfile:

    gem 'cancan_strong_parameters'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cancan_strong_parameters

## Rails 3

Rails 3 users must require `strong_parameters` in their Gemfiles manually.

    gem 'strong_parameters', '>= 0.1.6'

Alternatively, you can use versions of this gem below 0.3.

## Usage

1. Add `gem "cancan_strong_parameters"` to your Gemfile
2. In your controllers, wherever you use `load_and_authorize_resource` (and similar CanCan methods), also permit your parameters:

   ```ruby
   class PostsController < ApplicationController
      ...
      load_and_authorize_resource
      
      permit_params :body, tags: [:name]
      # --> permit_params allows parameters but doesn't require them.
      # In the preceding, :tags are a nested resource of post, while
      # :body is an attribute of a Post.
      #
      # :tags is plural here because it's a has_many association, but
      # you should use a singular key for a has_one.
      
      require_params :title
      # --> require_params works exactly the same, but throws an error
      # if the parameter isn't provided.
      
      # You can also require/permit params on create or update only:
      permit_params_on_create ...
      permit_params_on_update ...
      require_params_on_create ...
   end
   ```
3. Finally, don't forget to make the vars you use in your controllers
   accessible in your models:
   
   ```ruby
   class Post < ActiveRecord::Base
      attr_accessible :title, :body, :tags_attributes
   end
   ```

## Checkboxes

_Credit: @jlee42_

With 0.3, `cancan_strong_parameters` now supports checkboxes in forms, like `tag_ids`.

In order to avoid confusion with other nested attributes in a call to `permit_params`, please use the actual `Array` class object:

```ruby
class BlogPost < ActiveModel::Base
  permit_params :title, :content, tag_ids: Array
end
```

## Usage with other gems

It's possible to use `cancan_strong_parameters` with other gems, like Active Admin:

```ruby
ActiveAdmin.register Member do
  controller do
    permit_params :project_id, :name, :email
  end
end
```

(Thanks to @joshhepworth!)
        
## Testing

Run with `bundle exec rake test`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog

* Fixed docs to be compatible with 0.1.5.
* Fixed some issues with nested form subfields in `permit_params`
* Made compatible for nested forms
* Added default allows for _destroy.
* Tests pass in Travis.
* Fixes for irregular parameters posted like {"child_attributes" => {"0" => {}}}.
* Fixed a major security problem where I was manually inserting IDs - should be allowed by default, but not manually added
