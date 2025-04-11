class OrdersController < ApplicationController
  def create
    @order = Current.user.orders.build(order_params)

    respond_to do |format|
      if @order.place_order
        items = @order.line_items.map(&:itemizable).map(&:title).map(&:downcase)
        format.html { redirect_back(fallback_location: root_path, notice: "Your #{items.to_sentence} order was successfully placed.") }
      else
        format.html { redirect_back(fallback_location: root_path, alert: "Order could not be placed: #{@order.errors.full_messages.join(', ')}") }
      end
    end
  end

  private
    def order_params
      params.require(:order).permit(
        line_items_attributes: [
          :id,
          :itemizable_type,
          :itemizable_id,
          :_destroy
        ]
      )
    end
end
