class Reward < ApplicationRecord
  validates :points, numericality: { greater_than: 0 }
end
