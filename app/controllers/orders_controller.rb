class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show ]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Current.user.orders.build(order_params)

    respond_to do |format|
      if @order.place_order
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render :new, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_order
      @order = Order.find(params[:id])
    end

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
