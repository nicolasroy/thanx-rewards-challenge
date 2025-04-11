require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @order = orders(:one)
    @reward = rewards(:one)
    @reward2 = rewards(:two)
    sign_in(@user)
  end

  context "POST #create" do
    should "create order with single line item" do
      assert_difference("Order.count") do
        post orders_url, params: {
          order: {
            line_items_attributes: [ {
              itemizable_type: "Reward",
              itemizable_id: @reward.id.to_s
            } ]
          }
        }
      end

      assert_redirected_to root_path
      assert_equal 1, Order.last.line_items.count
      assert_equal @reward, Order.last.line_items.first.itemizable
    end

    should "create order with multiple line items" do
      assert_difference("Order.count") do
        assert_difference("LineItem.count", 2) do
          post orders_url, params: {
            order: {
              line_items_attributes: [
                {
                  itemizable_type: "Reward",
                  itemizable_id: @reward.id
                },
                {
                  itemizable_type: "Reward",
                  itemizable_id: @reward2.id
                }
              ]
            }
          }
        end
      end

      assert_redirected_to root_path
      assert_equal 2, Order.last.line_items.count
      assert_includes Order.last.line_items.map(&:itemizable), @reward
      assert_includes Order.last.line_items.map(&:itemizable), @reward2
    end

    should "handle errors" do
      @user.points.destroy_all

      assert_no_difference("Order.count") do
        post orders_url, params: {
          order: {
            line_items_attributes: [ {
              itemizable_type: "Reward",
              itemizable_id: @reward.id
            } ]
          }
        }
      end

      assert_redirected_to root_path
      assert_equal "Order could not be placed: Points balance is insufficient", flash[:alert]
    end
  end
end
