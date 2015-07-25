require 'test_helper'

class ChatterBotControllerTest < ActionController::TestCase
  test "should get chat" do
    get :chat
    assert_response :success
  end

end
