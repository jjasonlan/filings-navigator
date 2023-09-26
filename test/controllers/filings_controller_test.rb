require "test_helper"

class FilingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get filings_index_url
    assert_response :success
  end

  test "should get show" do
    get filings_show_url
    assert_response :success
  end

  test "should get upload" do
    get filings_upload_url
    assert_response :success
  end
end
