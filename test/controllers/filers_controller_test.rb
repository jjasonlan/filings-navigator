require "test_helper"

class FilersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get filers_index_url
    assert_response :success
  end
end
