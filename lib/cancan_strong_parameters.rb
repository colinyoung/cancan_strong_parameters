require "active_support/hash_with_indifferent_access"
require "cancan_strong_parameters/version"
require "cancan_strong_parameters/controller"
require "cancan_strong_parameters/deep_permit"
require "cancan_strong_parameters/rails/controller/base" if defined?(Rails)

module CancanStrongParameters
end