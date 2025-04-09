class Point < ApplicationRecord
  belongs_to :user
  # belongs_to :transaction, optional: true
end
