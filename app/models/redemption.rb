class Redemption < Point
  validates :amount, numericality: { less_than: 0 }
end
