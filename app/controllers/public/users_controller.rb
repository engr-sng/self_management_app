class Public::UsersController < ApplicationController

  def dashboard
    @user = User.find(current_user.id)
  end

  def show
    @user = User.find(current_user.id)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to my_page_path
      flash[:notice] = "プロフィールの更新に成功しました。"
    else
      flash[:alert] = "プロフィールの更新に失敗しました。"
      render :edit
    end
  end

  def confirm

  end

  def deactivate
    user = User.find(current_user.id)
    if user.update(is_deleted: true)
      reset_session
      flash[:notice] = "退会処理の実行に成功しました"
      redirect_to root_path
    else
      flash[:alert] = "退会処理の実行に失敗しました。"
      render :confirm
    end
  end


  private

  def user_params
    params.require(:user).permit(:display_name, :user_name, :email, :profile_image)
  end
end
