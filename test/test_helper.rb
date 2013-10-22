require 'require_all'

require 'minitest/autorun'

require 'cancan_strong_parameters'

## Boot up an instance of rails
require 'rails_helper'
require 'rails/test_help'

## Custom matchers
require 'assertions/assert_same_content'

module MiniTest::Expectations
  infect_an_assertion :assert_same_content, :must_have_same_content_as
  infect_an_assertion :refute_same_content, :wont_have_same_content_as
end
