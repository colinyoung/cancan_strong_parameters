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
  
  test "can handle multiple items" do
    params = {
      post: {
        title: "Hello",
        comments_attributes: {
          "0" => {
            body: "Comment 1",
            tags_attributes: {
              "0" => {
                name: "article"
              },
              "1" => {
                name: "post"
              },
            }
          },
          "1" => {
            body: "Comment 2"
          },
          "new_3904949" => {
            body: "Comment 3"
          }
        }
      }
    }
    
    post :create, params
    assert_equal \
      ActiveSupport::HashWithIndifferentAccess.new(assigns(:post_attributes)),
      ActiveSupport::HashWithIndifferentAccess.new({
        title: "Hello",
        comments_attributes: [
          {
            body: "Comment 1",
            tags_attributes: [{
                name: "article"
              },
              {
                name: "post"
              }
            ]
          },
          {
            body: "Comment 2"
          },
          {
            body: "Comment 3"
          }
        ]
      })
  end
end