class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :itemizable, polymorphic: true

  validates :itemizable, presence: true
end
