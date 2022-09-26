class Admin::HomesController < ApplicationController

  before_action :authenticate_admin!

  def top
    @users = User.all
    all_user = @users.count
    invalid_user = @users.where(is_deleted: true).count
    valid_user = @users.where(is_deleted: false).count

    if invalid_user == 0
      @withdrawal_rate = 0
    elsif valid_user == 0
      @withdrawal_rate = 0
    else
      @withdrawal_rate = ((invalid_user*100)/all_user).floor
    end
  end
end
