module CanCan
  class ControllerResource
    def load_resource_with_secure_params(*args)
      secure_params!
      load_resource_without_secure_params # This name comes from alias_method_chain. The params are already secured.
    end
    
    def secure_params!
      controller = @controller
      if controller.params.respond_to?(:require)
        protected_actions = controller.respond_to?(:protected_actions) ? controller.protected_actions : ['create', 'update']
        if protected_actions.include?(controller.action_name)
          internal_keys = ['controller', 'action', 'authenticity_token', 'commit', 'utf8']
          internal_values = @params.select {|k,v| internal_keys.include?(k) }        
          @params = ({resource_class.name.downcase => controller.secure_params}.merge(internal_values))
          @params = ActiveSupport::HashWithIndifferentAccess.new(@params)
        end
      end
    end
    
    alias_method_chain :load_resource, :secure_params
  end
end