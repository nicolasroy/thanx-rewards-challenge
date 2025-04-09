class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :points, dependent: :destroy
  has_many :redemptions, dependent: :destroy
  has_many :earnings, dependent: :destroy
  has_many :orders, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def balance
    points.sum(:amount)
  end
end
