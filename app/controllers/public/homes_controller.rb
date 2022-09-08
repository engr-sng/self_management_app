class Public::HomesController < ApplicationController
  def top
  end

  def about
  end

  def dashboard
    @user = User.find(current_user.id)
    @join_projects = @user.project_members
    @my_tasks = @user.child_tasks
  end

end
