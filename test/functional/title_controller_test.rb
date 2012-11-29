require 'test_helper'

class TitleControllerTest < ActionController::TestCase

  test "can manually change resource_name" do
    
    new_title = 'Changed title'
    put :update, 
      :id => 1,
      :post => {
        :title => new_title
      }
    
    assert_equal assigns[:post].title, new_title
  end
  
end