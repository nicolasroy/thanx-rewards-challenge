class RedemptionsController < ApplicationController
  def index
    @redemptions = Redemption.where(user: Current.user).all
  end
end
