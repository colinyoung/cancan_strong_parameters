module CancanStrongParameters
  module Controller
    
    HASH_DEFAULTS = ['id', '_destroy', '_delete']
    
    module ClassMethods
      # Use this with CanCan's load_resource to permit a set of params before
      # it tries to build or update a resource with them.
      #
      # Usage:
      #   class BooksController < ApplicationController
      #     load_resource :book
      #     permit_params book: [:title, :isbn]
      #   end
      #
      # Or:
      #   class BooksController < ApplicationController
      #     load_resource
      #     permit_params :title, :isbn
      #   end
      #
      # the second form should work in the simple case where you don't have to
      # supply a resource name for #load_resource
      #
      def permit_params *keys
        filter_strong_params :permit, [:all], keys
      end

      # Like permit_params, but only applies to create action
      #
      def permit_params_on_create *keys
        filter_strong_params :permit, [:create], keys
      end

      # Like permit_params, but only applies to update action
      #
      def permit_params_on_update *keys
        filter_strong_params :permit, [:update], keys
      end

      # Like permit_params, but marks the params required
      #
      def require_params *keys
        filter_strong_params :require, [:create, :update], keys
      end

      # Like require_params, but only applies to create action
      #
      def require_params_on_create *keys
        filter_strong_params :require, [:create], keys
      end

      # Like require_params, but only applies to update action
      #
      def require_params_on_update *keys
        filter_strong_params :require, [:update], keys
      end

      # Does a permit! at every level of the params to let everything through
      #
      def permit_all_params options = {}
        prepend_before_filter do
          self.params.deep_permit!
        end
      end

      def filter_strong_params method, actions, keys # :nodoc:
        # Get hash from end of array
        hash = keys.extract_options!
        keys.flatten!
        
        # Filter_options is passed to our before filter, e.g. sets when they run
        filter_options = actions == [:all] ? {} : { :only => actions }
  
        # Handle attributes if permitted attributes are given for nested models
        if (hash.present? && keys.present?) || (hash.select{|k,v| v.is_a?(Array)} == hash)
          
          defaults = CancanStrongParameters::Controller::HASH_DEFAULTS
          
          prepend_before_filter(filter_options) do
            resource_name = self.class.resource_name
            
            parameters = keys.flatten + defaults
            parameters << ActionController::Parameters.new(hash.attributized)
            
            # original: parameters = keys.flatten + defaults
            #           parameters << hash
            unless params[resource_name]
              warn("Not updating - no parameters key present for #{resource_name}") 
            else
              self.params[resource_name] = params[resource_name].standardized.send method, *parameters
            end
          end
        elsif hash.present?
          prepend_before_filter(filter_options) do
            self.params.merge! params.send(method, hash)
          end
        else
          prepend_before_filter(filter_options) do
            resource_name = self.class.resource_name
            if params.has_key?(resource_name)
              self.params[resource_name] = params[resource_name].send method, *keys
            else
              self.params = params.send method, *keys
            end
          end
        end
      end

      def resource_name(name_to_set=nil)
        unless name_to_set.present?
          @resource_name ||= self.to_s.sub("Controller", "").underscore.split('/').last.singularize
        else
          @resource_name = name_to_set
        end
      end
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    # Errors
    def warn msg
      if Rails and Rails.logger
        Rails.logger.warn(msg)
      end
    end

  end
end

class Hash
  
  # Converts keys with hash values -- e.g. posts: {} -- to posts_attributes for nested forms.
  # 
  # Also, Allows rails specific values like _destroy or _delete.
  # 
  # NOTE: You must enable `allow_destroy: true` in your call to `accepts_nested_attributes_for` anyway,
  # so this is secure to whitelist here.
  def attributized
    defaults = CancanStrongParameters::Controller::HASH_DEFAULTS
    
    Hash.new.tap do |h|
      self.each do |k,v|
        if v.respond_to? :attributized
          h[:"#{k}_attributes"] = v.attributized + defaults
        else
          h[k] = v == Array ? [] : v
        end
      end
    end
  end
  
  # Converts keyed nested_forms (like task_attributes: {"0" => {}}) to normal params arrays.
  def to_parameter_array
    if self.empty? or !((k = self.keys.first).is_a?(String) and k[0..3] == "new_" or k.is_i? or k.is_hex?)
      self
    else
      Array.new.tap do |a|
        self.each do |k,v|
          a << v.standardized
        end
      end
    end
  end
end

class Array
  
  # Attributizes each element in an array
  def attributized
    Array.new.tap do |a|
      self.each do |v|
        v = v.attributized if v.is_a?(Hash)
        a << v
      end
    end
  end
end

class ActiveSupport::HashWithIndifferentAccess
  
  # Takes params that are passed in for nested_forms (like the example below) and cleans them up.
  #
  # post: {
  #   comments_attributes: {
  #     "0" => {},
  #     "1" => {},  
  #     "new_23023032" => {}
  #   }
  # }
  #
  def standardized
    ActionController::Parameters.new.tap do |h|
      self.each do |k,v|
        h[k] = v.is_a?(Hash) ? v.to_parameter_array : v
      end
    end
  end
end

class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
  
  def is_hex?
    !!(self =~ /^[0-9a-f]+$/)
  end
end
