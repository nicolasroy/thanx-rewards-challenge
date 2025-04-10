require "test_helper"

class RewardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reward = rewards(:one)
    @user = users(:one)
    sign_in(@user)
  end

  context "GET #index" do
    should "get index" do
      get rewards_url
      assert_response :success
    end
  end
end
