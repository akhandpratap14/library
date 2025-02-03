require "test_helper"

class RenewalRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get renewal_requests_create_url
    assert_response :success
  end
end
