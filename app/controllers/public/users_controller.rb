class Public::UsersController < ApplicationController

  def dashboard
    @user = User.find(current_user.id)
    @join_projects = @user.project_members
    @my_tasks = @user.child_tasks
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

  private

  def user_params
    params.require(:user).permit(:display_name, :user_name, :email)
  end
end
