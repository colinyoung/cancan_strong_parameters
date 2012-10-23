class Post
  include ActiveModel::Serialization
  include ActiveModel::MassAssignmentSecurity
  
  attr_accessible :body, :content
end