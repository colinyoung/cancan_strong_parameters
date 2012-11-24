require 'test_helper'

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
    
    post :create, params
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
  
  test "can handle multiple items but with only new itesm" do
    params = {
      post: {
        title: "Hello",
        comments_attributes: {
          "new_3904949" => {
            body: "Comment 3",
            tags_attributes: {
              "new_23040234" => {
                name: "article"
              }
            }
          }
        }
      }
    }
    
    post :create, params
    assert_equal \
      ActiveSupport::HashWithIndifferentAccess.new(assigns(:post_attributes)),
      ActiveSupport::HashWithIndifferentAccess.new({
        title: "Hello",
        comments_attributes: [{
          body: "Comment 3",
          tags_attributes: [{
              name: "article"
          }]
        }]
      })
  end
end