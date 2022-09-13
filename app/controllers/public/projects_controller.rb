class Public::ProjectsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_project_member, only: [:update, :edit, :destroy]

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project_new = Project.new
  end

  def create
    @project_new = Project.new(project_params)
    @project_new.user_id = current_user.id
    start_date = params[:project][:start_date]
    end_date = params[:project][:end_date]
    if  @project_new.save
      @project_new.initial_project_format(start_date,end_date)
      redirect_to project_path(@project_new.id)
      flash[:notice] = "プロジェクトの新規作成に成功しました。"
    else
      flash[:alert] = "プロジェクトの新規作成に失敗しました。"
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    before_project_owner = @project.user_id
    if @project.update(project_params)
      if before_project_owner != @project.user_id
        project_owner = ProjectMember.find_by(project_id: @project.id, user_id: @project.user_id)
        project_owner.update(permission: 20)
      end
      redirect_to project_path(@project.id)
      flash[:notice] = "プロジェクトの更新に成功しました。"
    else
      flash[:alert] = "プロジェクトの更新に失敗しました。"
      render :show
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      redirect_to dashboard_path
      flash[:notice] = "プロジェクトの削除に成功しました。"
    else
      flash[:alert] = "プロジェクトの削除に失敗しました。"
      render :edit
    end
  end

  private

  def project_params
    params.require(:project).permit(:user_id,:title,:description)
  end

  def ensure_project_member
      user = User.find(current_user.id)
      project = Project.find(params[:id])
      project_member = ProjectMember.find_by(project_id: project.id, user_id: user.id)
    unless ProjectMember.permissions[project_member.permission] >= 20
      redirect_to project_path(project.id)
      flash[:alert] = "プロジェクトの編集には管理者権限が必要です。"
    end
  end
end