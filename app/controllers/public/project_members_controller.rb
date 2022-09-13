class Public::ProjectMembersController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_project_member, only: [:new, :create,:edit,:update,:destroy]

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

  def show
    @project_member = ProjectMember.find(params[:id])
  end

  def edit
    @project_member = ProjectMember.find(params[:id])
  end

  def update
    @project_member = ProjectMember.find(params[:id])

    if @project_member.user_id == @project_member.project.user_id
      flash[:alert] = "プロジェクトオーナーの権限は変更できません。"
      render :edit
    elsif @project_member.update(project_member_params)
      redirect_to project_path(@project_member.project.id)
      flash[:notice] = "プロジェクトメンバーの更新に成功しました。"
    else
      flash[:alert] = "プロジェクトメンバーの更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @project_member = ProjectMember.find(params[:id])

    if @project_member.user_id == @project_member.project.user_id
      flash[:alert] = "プロジェクトオーナーは削除できません。"
      render :show
    elsif @project_member.destroy
      @project_member.project.child_tasks.where(user_id: @project_member.user_id).each do |child_task|
        child_task.update(user_id: current_user.id)
      end
      redirect_to project_path(@project_member.project.id)
      flash[:notice] = "プロジェクトメンバーの削除に成功しました。"
    else
      flash[:alert] = "プロジェクトメンバーの削除に失敗しました。"
      render :show
    end
  end

  private

  def project_member_params
    params.require(:project_member).permit(:user_id,:project_id,:permission)
  end

  def ensure_project_member
      user = User.find(current_user.id)
      project = Project.find(params[:project_id])
      project_member = ProjectMember.find_by(project_id: project.id, user_id: user.id)
    unless ProjectMember.permissions[project_member.permission] >= 20
      redirect_to project_path(project.id)
      flash[:alert] = "プロジェクトメンバーの追加や編集には管理者権限が必要です。"
    end
  end

end
