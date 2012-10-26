class Post
  include ActiveModel::Serialization
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::AttributeMethods
  
  attr_accessible :body, :content
  
  def initialize(attributes = {})
    @attributes = attributes
  end
end