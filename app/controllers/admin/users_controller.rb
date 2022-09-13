class Admin::UsersController < ApplicationController

  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id)
      flash[:notice] = "プロフィールの更新に成功しました。"
    else
      flash[:alert] = "プロフィールの更新に失敗しました。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:display_name, :user_name, :email, :is_deleted)
  end

end
