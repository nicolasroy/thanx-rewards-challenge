class Order < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :line_items, allow_destroy: true

  validates :line_items, presence: true

  def place_order
    return unless new_record?
    return unless valid?

    transaction do
      # Preserve integrity of the points balance during the transaction
      user.lock!

      if insufficient_balance?
        errors.add(:base, "Points balance is insufficient")
        return
      end

      save!

      redeem_points
    end
  end

  def place_order!
    place_order || raise(ActiveRecord::RecordInvalid.new(self))
  end

  def total_points_redeeming
    line_items.select { |item| item.itemizable_type == "Reward" }
              .sum { |item| item.itemizable.points }
  end

  private

  def redeem_points
    user.redemptions.create!(
      amount: -total_points_redeeming,
      order: self
    )
  end

  def insufficient_balance?
    user.balance < total_points_redeeming
  end
end
