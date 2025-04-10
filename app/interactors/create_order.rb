class CreateOrder
  include Interactor

  delegate :order, to: :context

  def call
    return unless order.valid?

    User.transaction do
      # Preserve integrity of the points balance during the transaction
      order.user.lock!

      if insufficient_points_balance?
        context.fail!(error: "Points balance is insufficient")
        return
      end

      order.save!

      redeem_points
    end
  end

  private

  def redeem_points
    order.user.redemptions.create!(
      amount: -order.total_points_redeeming,
      order: order
    )
  end

  def insufficient_points_balance?
    order.user.balance < order.total_points_redeeming
  end
end
