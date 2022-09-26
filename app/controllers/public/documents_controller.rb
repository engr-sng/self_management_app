class Public::DocumentsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_project_member, only: [:new, :create, :edit, :update, :destroy]

  def new
    @project = Project.find(params[:project_id])
    @document_new = Document.new
  end

  def show
    @document = Document.find(params[:id])
  end

  def create
    @project = Project.find(params[:project_id])
    @document_new = Document.new(document_params)
    @document_new.project_id = @project.id
    @document_new.user_id = current_user.id
    if @document_new.save
      redirect_to project_path(@document_new.project.id)
      flash[:notice] = "資料の新規作成に成功しました。"
    else
      flash.now[:alert] = "資料の新規作成に失敗しました。"
      render :new
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    if @document.update(document_params)
      redirect_to project_path(@document.project.id)
      flash[:notice] = "資料の編集に成功しました。"
    else
      flash.now[:alert] = "資料の編集に失敗しました。"
      render :edit
    end
  end

  def destroy
    @document = Document.find(params[:id])
    if @document.destroy
      redirect_to project_path(@document.project.id)
      flash[:notice] = "資料の削除に成功しました。"
    else
      flash.now[:alert] = "資料の削除に失敗しました。"
      render :show
    end

  end

  private

  def document_params
    params.require(:document).permit(:title, :description, :url, :user_id, :project_id)
  end

  def ensure_project_member
      user = User.find(current_user.id)
      project = Project.find(params[:project_id])
      project_member = ProjectMember.find_by(project_id: project.id, user_id: user.id)
    unless ProjectMember.permissions[project_member.permission] >= 10
      redirect_to project_path(project.id)
      flash[:alert] = "資料の追加や編集には編集権限、または管理者権限が必要です。"
    end
  end

end
