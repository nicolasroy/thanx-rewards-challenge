require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @first_reward = rewards(:one)
    @order = orders(:one).dup
    @order.line_items.build(itemizable: @first_reward)
  end

  context "total_points_redeeming" do
    should "return the total points of all Rewards in the order" do
      assert_equal @first_reward.points, @order.total_points_redeeming
    end

    should "return 0 when there are no rewards in the order" do
      @order.line_items = []
      assert_equal 0, @order.total_points_redeeming
    end
  end
end
