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

Wherever you use `load_and_authorize_resource`, also add: `permit_params`
    
    class PeopleController < ActionController::Base
      load_and_authorize_resource :person
      permit_params person: [:name, :age]
      
      # This will raise an ActiveModel::ForbiddenAttributes exception because it's using mass assignment
      # without an explicit permit step.
      def create
        Person.create(params[:person])
      end

      # This will pass with flying colors as long as there's a person key in the parameters, otherwise
      # it'll raise a ActionController::MissingParameter exception, which will get caught by
      # ActionController::Base and turned into that 400 Bad Request reply.
      def update
        redirect_to current_account.people.find(params[:id]).tap { |person|
          person.update_attributes!(person_params)
        }
      end

      private
        # Using a private method to encapsulate the permissible parameters is just a good pattern
        # since you'll be able to reuse the same permit list between create and update. Also, you
        # can specialize this method with per-user checking of permissible attributes.
        def person_params
          params.require(:person).permit(:name, :age)
        end
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
