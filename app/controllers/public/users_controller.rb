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

  end

  def update

  end

end
