class Earning < Point
  validates :amount, numericality: { greater_than: 0 }
end
