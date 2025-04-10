require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  context "balance" do
    should "return the amount of points a user can spend" do
      assert_equal 97, @user.balance
    end

    should "include new earnings" do
      @user.earnings.create! amount: 3

      assert_equal 100, @user.balance
    end

    should "exclude points that are already spent" do
      @user.redemptions.create! amount: -22

      assert_equal 75, @user.balance
    end

    should "return 0 when it has no points" do
      @user.points.destroy_all

      assert_equal 0, @user.balance
    end
  end
end
