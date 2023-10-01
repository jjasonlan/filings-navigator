require "test_helper"

class RecipientsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recipients_index_url
    assert_response :success
  end
end
