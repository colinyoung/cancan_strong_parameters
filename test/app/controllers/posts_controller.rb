class PostsController < ActionController::Base
  include CancanStrongParameters::Controller
  
  permit_params :title, :content,
    comments: [
      :body, tags: [:name]
    ]
    
  def create
    @post = Post.new(params[:post])
    @post_attributes = params[:post]
    render json: @post
  end
  alias_method :update, :create
  
end