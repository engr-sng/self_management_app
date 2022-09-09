class Public::ProjectsController < ApplicationController

  def index
  end

  def show
    @project = Project.find(params[:id])
    @project_members = @project.project_members
  end

  def new
    @project_new = Project.new
  end

  def create
    @project_new = Project.new(project_params)
    @project_new.user_id = current_user.id
    if  @project_new.save
      @project_new.initial_project_format
      redirect_to project_path(@project_new.id)
      flash[:notice] = "プロジェクトの新規作成に成功しました。"
    else
      flash[:alert] = "プロジェクトの新規作成に失敗しました。"
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
    @project_members = @project.project_members.pluck(:user_id).map {|k|[User.find(k).user_name,k]}
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to project_path(@project.id)
      flash[:notice] = "プロジェクトの更新に成功しました。"
    else
      flash[:alert] = "プロジェクトの更新に失敗しました。"
      render :show
    end
  end

  def destroy
  end

  private

  def project_params
    params.require(:project).permit(:user_id,:title,:description,:start_date,:end_date,:status,:progress)
  end

end
