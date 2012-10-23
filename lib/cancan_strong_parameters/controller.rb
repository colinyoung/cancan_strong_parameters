module CancanStrongParameters
  module Controller
    
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
        filter_strong_params :permit, [:create, :update], keys
      end

      # Like permit_params, but only applies to create action
      #
      def permit_params_on_create *keys
        filter_strong_params :permit, :create, keys
      end

      # Like permit_params, but only applies to update action
      #
      def permit_params_on_update *keys
        filter_strong_params :permit, :update, keys
      end

      # Like permit_params, but marks the params required
      #
      def require_params *keys
        filter_strong_params :require, [:create, :update], keys
      end

      # Like require_params, but only applies to create action
      #
      def require_params_on_create *keys
        filter_strong_params :require, :create, keys
      end

      # Like require_params, but only applies to update action
      #
      def require_params_on_update *keys
        filter_strong_params :require, :update, keys
      end

      # Does a permit! at every level of the params to let everything through
      #
      def permit_all_params options = {}
        prepend_before_filter options.reverse_merge(:only => [:create, :update]) do
          self.params.deep_permit!
        end
      end

      def filter_strong_params method, actions, keys # :nodoc:
        h = keys.dup
        hash = keys.extract_options!
        keys.flatten!
  
        # Handle attributes if permitted attributes are given for nested models
        if (hash.present? && keys.present?) || (hash.select{|k,v| v.is_a?(Array)} == hash)
          prepend_before_filter :only => actions do
            resource_name = self.class.resource_name
            hash = hash.attributized
            self.params[resource_name] = params[resource_name].send method, *[*keys.flatten, hash]
          end
        elsif hash.present?
          prepend_before_filter :only => actions do
            self.params.merge! params.send(method, hash)
          end
        else
          prepend_before_filter :only => actions do
            resource_name = self.class.resource_name
            if params.has_key?(resource_name)
              self.params[resource_name] = params[resource_name].send method, *keys
            else
              self.params = params.send method, *keys
            end
          end
        end
      end

      def resource_name
        self.to_s.sub("Controller", "").underscore.split('/').last.singularize
      end
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end

class Hash
  def attributized
    Hash.new.tap do |h|
      self.each do |k,v|
        h[:"#{k}_attributes"] = self.delete(k).attributized
      end
    end
  end
end

class Array
  def attributized
    Array.new.tap do |a|
      self.each do |v|
        v = v.attributized if v.is_a?(Hash)
        a << v
      end
    end
  end
end