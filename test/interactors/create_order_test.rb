require "test_helper"

class CreateOrderTest < ActiveSupport::TestCase
  setup do
    @first_reward = rewards(:one)
    @second_reward = rewards(:two)
    @order = orders(:one).dup
    @order.line_items.build(itemizable: @first_reward)
  end

  context "Creating an order" do
    should "redeem points when the order is created" do
      assert_difference "Redemption.count", 1 do
        result = CreateOrder.call(order: @order)
        assert result.success?
      end
    end

    should "redeem the total amount of points for the order" do
      @order.line_items.build(itemizable: @second_reward)
      result = CreateOrder.call(order: @order)
      assert result.success?

      assert_equal -@order.total_points_redeeming, Redemption.last.amount
    end

    should "fail when the user's balance of points is insufficient" do
      @order.user.points.destroy_all

      assert_no_difference "Redemption.count" do
        assert_no_difference "Order.count" do
          result = CreateOrder.call(order: @order)
          assert_not result.success?
          assert_equal "Points balance is insufficient", result.error
        end
      end
    end

    should "prevent concurrent order creation for the same user" do
      second_order = @order.dup
      second_order.line_items.build(itemizable: @first_reward)

      # provide enough points for only one order
      @order.user.points.destroy_all
      @order.user.earnings.create!(amount: @first_reward.points)

      assert_difference "Order.count", 1 do
        threads = []
        threads << Thread.new do
          CreateOrder.call(order: @order)
        end
        threads << Thread.new do
          CreateOrder.call(order: second_order)
        end
        threads.each(&:join)
      end

      assert_equal 0, @order.user.balance
    end
  end
end
