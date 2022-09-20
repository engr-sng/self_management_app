class Public::DocumentsController < ApplicationController

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
      redirect_to project_path(@document_new.project_id)
      flash[:notice] = "資料の新規作成に成功しました。"
    else
      flash[:alert] = "資料の新規作成に失敗しました。"
      render :new
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @document = Document.find(params[:id])
    if @document.update(document_params)
      redirect_to project_path(@document.project_id)
      flash[:notice] = "資料の編集に成功しました。"
    else
      flash[:alert] = "資料の編集に失敗しました。"
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @document = Document.find(params[:id])
    if @document.destroy
      redirect_to project_path(@document.project_id)
      flash[:notice] = "資料の削除に成功しました。"
    else
      flash[:alert] = "資料の削除に失敗しました。"
      render :show
    end

  end

  private

  def document_params
    params.require(:document).permit(:title, :description, :url, :user_id, :project_id)
  end
end
