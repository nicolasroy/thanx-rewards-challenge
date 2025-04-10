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

  context "GET #new" do
    should "get new" do
      get new_reward_url
      assert_response :success
    end
  end

  context "POST #create" do
    should "create reward" do
      assert_difference("Reward.count") do
        post rewards_url, params: { reward: { title: "a new reward", content: @reward.content, image: @reward.image, points: @reward.points } }
      end

      assert_redirected_to reward_url(Reward.last)
    end
  end

  context "GET #show" do
    should "show reward" do
      get reward_url(@reward)
      assert_response :success
    end
  end

  context "GET #edit" do
    should "get edit" do
      get edit_reward_url(@reward)
      assert_response :success
    end
  end

  context "PATCH #update" do
    should "update reward" do
      patch reward_url(@reward), params: { reward: { content: @reward.content, image: @reward.image, points: @reward.points, title: @reward.title } }
      assert_redirected_to reward_url(@reward)
    end
  end

  context "DELETE #destroy" do
    should "destroy reward" do
      assert_difference("Reward.count", -1) do
        delete reward_url(@reward)
      end

      assert_redirected_to rewards_url
    end
  end
end
