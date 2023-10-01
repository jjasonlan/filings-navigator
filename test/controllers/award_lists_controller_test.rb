require "test_helper"

class AwardListsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get award_lists_index_url
    assert_response :success
  end
end
