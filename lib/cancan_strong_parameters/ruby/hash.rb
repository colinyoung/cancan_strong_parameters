require "active_support/hash_with_indifferent_access"

class Hash
  def indifferent
    ActiveSupport::HashWithIndifferentAccess.new(self)
  end
  alias :indifferent_access :indifferent
end