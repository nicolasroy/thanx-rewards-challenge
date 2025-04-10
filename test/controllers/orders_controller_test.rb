require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @order = orders(:one)
    @reward = rewards(:one)
    @reward2 = rewards(:two)
    sign_in(@user)
  end

  context "GET #index" do
    should "get index" do
      get orders_url
      assert_response :success
    end
  end

  context "GET #new" do
    should "get new" do
      get new_order_url
      assert_response :success
    end
  end

  context "POST #create" do
    should "create order with single line item" do
      assert_difference("Order.count") do
        post orders_url, params: {
          order: {
            line_items_attributes: [ {
              itemizable_type: "Reward",
              itemizable_id: @reward.id
            } ]
          }
        }
      end

      assert_redirected_to order_url(Order.last)
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

      assert_redirected_to order_url(Order.last)
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

      assert_response :unprocessable_entity
    end
  end

  context "GET #show" do
    should "show order" do
      get order_url(@order)
      assert_response :success
    end
  end
end
