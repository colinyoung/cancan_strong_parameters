module CancanStrongParameters
  module DeepPermit 
    def deep_permit!
      self.each do |key, value|
        if value.is_a?(Hash)
          if !value.respond_to?(:permit!)
            self[key] = value = ActionController::Parameters.new(value)
          end
          value.deep_permit!
        end
      end
      permit!
    end
  end
end