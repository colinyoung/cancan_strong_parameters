require 'test_helper'

class ArrayControllerTest < ActionController::TestCase

  test "should allow only an Array param to be present" do

    new_label_ids = [1, 2, 3]
    put :update,
      :id => 1,
      :post => {
        :comment_ids => new_label_ids
      }

    assert_equal assigns[:post].label_ids, new_label_ids
  end

end
