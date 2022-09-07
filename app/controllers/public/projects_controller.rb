class Public::ProjectsController < ApplicationController

  def index
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project_new = Project.new

  end

  def create
    @project_new = Project.new(project_params)
    @project_new.user_id = current_user.id
    if  @project_new.save
      @project_new.initial_project_member
      @project_new.initial_project_format
      redirect_to project_path(@project_new.id)
      flash[:notice] = "プロジェクトの新規作成に成功しました。"
    else
      flash[:alert] = "プロジェクトの新規作成に失敗しました。"
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def project_params
    params.require(:project).permit(:title,:description,:start_date,:end_date)
  end

end
