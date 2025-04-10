class Order < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :line_items, allow_destroy: true


  def total_points_redeeming
    line_items.select { |item| item.itemizable_type == "Reward" }
              .sum { |item| item.itemizable.points }
  end
end
