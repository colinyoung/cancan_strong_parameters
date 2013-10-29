class ActionController::Base
  include CancanStrongParameters::Controller
end

class ActionController::Parameters
  include CancanStrongParameters::DeepPermit
end
