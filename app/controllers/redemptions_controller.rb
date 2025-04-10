class RedemptionsController < ApplicationController
  def index
    @redemptions = Redemption.where(user: Current.user).order(created_at: :desc).all
  end
end
