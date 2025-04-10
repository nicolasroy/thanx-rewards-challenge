require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @first_reward = rewards(:one)
    @second_reward = rewards(:two)
    @order = orders(:one).dup
    @order.line_items.build(itemizable: @first_reward)
  end

  context "Placing an order" do
    should "redeem points" do
      assert_difference "Redemption.count", 1 do
        assert @order.place_order
      end
    end

    should "redeem the total amount of points from the order's line items" do
      @order.line_items.build(itemizable: @second_reward)

      assert @order.place_order
      assert_equal (-@order.total_points_redeeming), Redemption.last.amount
    end

    should "fail when the user's balance of points is insufficient" do
      @order.user.points.destroy_all

      assert_no_difference "Redemption.count" do
        assert_no_difference "Order.count" do
          assert_not @order.place_order
          assert_equal "Points balance is insufficient", @order.errors.full_messages.first
        end
      end
    end

    should "fail when the order is not valid" do
      @order.line_items = []

      assert_no_difference "Redemption.count" do
        assert_no_difference "Order.count" do
          assert_not @order.place_order
          assert_equal "Line items can't be blank", @order.errors.full_messages.first
        end
      end
    end

    should "prevent concurrent order creation for the same user" do
      duplicate_order = @order.dup
      duplicate_order.line_items.build(itemizable: @first_reward)

      # provide enough points for only one order
      @order.user.points.destroy_all
      @order.user.earnings.create!(amount: @first_reward.points)

      assert_difference "Order.count", 1 do
        [
          Thread.new { @order.place_order },
          Thread.new { duplicate_order.place_order }
        ].each(&:join)
      end

      assert_equal 0, @order.user.balance
    end

    should "be placed only once" do
      @order.place_order

      assert_no_difference "Order.count" do
        assert_no_difference "Redemption.count" do
          @order.place_order
        end
      end
    end

    should "place order successfully when calling with a bang!" do
      assert_difference "Order.count", 1 do
          @order.place_order!
      end
    end

    should "raise an error on an invalid order when calling with a bang!" do
      @order.line_items = []

      assert_raises(ActiveRecord::RecordInvalid) do
        @order.place_order!
      end
    end
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
