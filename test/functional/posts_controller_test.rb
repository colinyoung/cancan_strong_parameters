require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  
  test "should not clip off deep params" do
    params = {
      :post => {
        :title => "Title of post",
        :content => "Post main content.",
        :comments_attributes => [{
          :body => "My comment.",
          :tags_attributes => [{
            :name => "article"
          }]
        }]
      }
    }
    
    post :create, params
    assigns(:post_attributes).indifferent.must_have_same_content_as params[:post].indifferent
  end
  
  test "keeps _destroy keys" do  
    params = {
      :post => {
        :_destroy => true
      }
    }
    
    post :create, params
    assigns(:post_attributes).indifferent.must_have_same_content_as params[:post].indifferent
  end
  
  test "can handle multiple items" do
    params = {
      :post => {
        :title => "Hello",
        :comments_attributes => {
          "0" => {
            :body => "Comment 1",
            :tags_attributes => {
              "0" => {
                :name => "article"
              },
              "1" => {
                :name => "post"
              },
            }
          },
          "1" => {
            :body => "Comment 2"
          },
          "new_3904949" => {
            :body => "Comment 3"
          }
        }
      }
    }
    
    post :create, params
    expected = {
      :title => "Hello",
      :comments_attributes => [
        {
          :body => "Comment 1",
          :tags_attributes => [{
              :name => "post"
            },
            {
              :name => "article"
            }
          ]
        },
        {
          :body => "Comment 2"
        },
        {
          :body => "Comment 3"
        }
      ]
    }
    assigns(:post_attributes).must_have_same_content_as expected.indifferent
  end
  
  test "can handle multiple items but with only new items" do
    params = {
      :post => {
        :title => "Hello",
        :comments_attributes => {
          "new_3904949" => {
            :body => "Comment 3",
            :tags_attributes => {
              "new_23040234" => {
                :name => "article"
              }
            }
          }
        }
      }
    }
    
    post :create, params
    expected = {
      :title => "Hello",
      :comments_attributes => [{
        :body => "Comment 3",
        :tags_attributes => [{
            :name => "article"
        }]
      }]
    }
    assigns(:post_attributes).indifferent.must_have_same_content_as expected.indifferent
  end
end