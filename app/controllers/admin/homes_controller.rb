class Admin::HomesController < ApplicationController

  before_action :authenticate_admin!

  def top
    @users = User.all
    invalid_user = @users.where(is_deleted: true).count
    valid_user = @users.where(is_deleted: false).count

    if @users.where(is_deleted: true).count == 0
      @withdrawal_rate = "バ"
    elsif @users.where(is_deleted: false).count == 0
      @withdrawal_rate = "カ"
    else
      @withdrawal_rate = ((invalid_user*100)/valid_user)
    end
  end
end
