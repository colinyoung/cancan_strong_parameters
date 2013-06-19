class Post
  include ActiveModel::Serialization
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::AttributeMethods
  
  attr_accessor :title, :body, :label_ids
  attr_accessible :title, :body, :label_ids
  
  def initialize(attributes = {})
    @attributes = attributes
  end
  
  # Fake persistence
  def self.sample_post
    new(:title => "Sample post", :body => "Sample body")
  end
  
  def self.find(*args)
    sample_post
  end
  
  def update_attributes(params)
    params.map do |k,v|
      setter = :"#{k}=" # setter
      self.send(setter, v) if self.respond_to?(setter)
    end
  end
end