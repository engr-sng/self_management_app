class Public::ProjectMembersController < ApplicationController

  before_action :authenticate_user!

  def new
    @project = Project.find(params[:project_id])
    @project_member_new = ProjectMember.new
  end

  def create
    @project_member_new = ProjectMember.new
    @user = User.find_by(user_name: params[:project_member][:user_name])
    @project = Project.find(params[:project_member][:project_id])

    if @user.nil?
      flash[:alert] = "選択したユーザーは存在しません。"
      render :new
    elsif ProjectMember.find_by(user_id: @user.id, project_id: @project.id)
      flash[:alert] = "選択したユーザーはすでにプロジェクトメンバーに追加されています。"
      render :new
    else
      @project_member_new = ProjectMember.new(
        user_id: @user.id,
        project_id: @project.id,
        permission: 0
        )
      if @project_member_new.save
        redirect_to project_path(@project_member_new.project_id)
        flash[:notice] = "メンバーの追加に成功しました。"
      else
        flash[:alert] = "メンバーの追加に失敗しました。"
        render :new
      end
    end

  end

  def update

  end

  def destroy

  end

  private

  def project_member_params
    params.require(:project_member).permit(:user_id,:project_id,:permission)
  end

end
