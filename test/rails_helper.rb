$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'

require 'debugger'

gem 'actionpack', '>= 3.0.0'
gem 'activesupport', '>= 3.0.0'
gem 'activemodel', '>= 3.0.0'
gem 'railties', '>= 3.0.0'

# Only the parts of rails we want to use
# if you want everything, use "rails/all"
require "action_controller/railtie"
require "active_model/railtie"
require "rails/test_unit/railtie"
require "rack/test"

root = File.expand_path(File.dirname(__FILE__))

# Define the application and configuration
module Config
  class Application < ::Rails::Application
    # configuration here if needed
    config.active_support.deprecation = :stderr 
  end
end

# Initialize the application
Config::Application.initialize!

Config::Application.routes.draw do
  resources :posts
  
  match 'title/:id', to: 'title#update', via: :put
end
