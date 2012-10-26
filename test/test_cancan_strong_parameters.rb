require 'minitest/autorun'

require 'require_all'

require 'strong_parameters'
require 'cancan_strong_parameters'

## Boot up an instance of rails
require 'rails_helper'
require 'rails/test_help'

class PostsControllerTest < ActionController::TestCase
  test "should not clip off deep params" do
    params = {
      post: {
        title: "Title of post",
        content: "Post main content.",
        comments_attributes: [{
          body: "My comment.",
          tags_attributes: [{
            name: "article"
          }]
        }]
      }
    }
    
    post :create, params
    assert_equal \
      ActiveSupport::HashWithIndifferentAccess.new(assigns(:post_attributes)),
      ActiveSupport::HashWithIndifferentAccess.new(params[:post])
  end
  
  test "keeps _destroy keys" do  
    params = {
      post: {
        _destroy: true
      }
    }
    
    put :update, {id: 1}.merge(params)
    assert_equal \
      ActiveSupport::HashWithIndifferentAccess.new(assigns(:post_attributes)),
      ActiveSupport::HashWithIndifferentAccess.new(params[:post])
  end
end