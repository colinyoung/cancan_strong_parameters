$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'

gem 'actionpack',         '~> 3.0'
gem 'activemodel',        '~> 3.0'
gem 'railties',           '~> 3.0'
gem 'strong_parameters',  '0.1.6'

# Only the parts of rails we want to use
# if you want everything, use "rails/all"
require "action_controller/railtie"
require "active_model/railtie"
require "rails/test_unit/railtie"
require "rack/test"

require 'strong_parameters' # when using an ordinary bundle, this wouldn't be required

root = File.expand_path(File.dirname(__FILE__))

# Define the application and configuration
module Test
  class Application < ::Rails::Application
    # configuration here if needed
    config.active_support.deprecation = :stderr 
  end
end

# Initialize the application
Test::Application.initialize!

Test::Application.routes.draw do
  resources :posts
  
  match 'title/:id', :to => 'title#update', :via => :put
end
