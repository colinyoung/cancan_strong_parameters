class PostsController < ActionController::Base
  include CancanStrongParameters::Controller
  
  permit_params :title, :content, :label_ids,
    :comments => [
      :body, 
      { :tags => [ :name ] } # This is fugly, use 1.9!
    ]
    
  def create
    @post = Post.new(params[:post])
    @post_attributes = params[:post]
    render :json => @post
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      render :json => @post
    else
      render :json => { :errors => post.errors.full_messages }, :status => :unprocessable_entity
    end
  end
  
end