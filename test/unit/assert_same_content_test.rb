require 'test_helper'

class SameContentTest < Test::Unit::TestCase

  def test_same_content_works
    ['a', 'b', 'c'].must_have_same_content_as ['b', 'a', 'c']
    ['a', 'b', 'c'].wont_have_same_content_as ['b', 'a', 'c', 'd']
    
    dog1 = {
      :breed => "Husky/Lab Mix",
      :name => "Rue",
      :tricks => {
        :not_jumping_up => false, # :( Workin on it!
        :sitting => true,
        :coming_when_called => true,
        :other => [
          {
            :name => "trick1",
            :value => false
          },
          {
            :name => "trick2",
            :value => true
          }
        ]
      }
    }
    
    dog2 = dog1.dup
    dog2[:tricks][:other].reverse!
    dog1.must_have_same_content_as dog2
  end
  
end