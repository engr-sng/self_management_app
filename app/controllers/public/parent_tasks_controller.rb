class Public::ParentTasksController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_project_member, only: [:new, :create, :edit, :update, :destroy,:bulk_new, :bulk_create, :bulk_edit, :bulk_update, :bulk_delete, :bulk_destroy]

  def new
    @project = Project.find(params[:project_id])
    @parent_task_new = ParentTask.new
  end

  def create
    @project = Project.find(params[:project_id])
    @parent_task_new = ParentTask.new(parent_task_params)
    @parent_task_new.project_id = @project.id
    @parent_task_new.display_order = @project.have_parent_task_get_max_display_order

    if @parent_task_new.save
      redirect_to project_path(@parent_task_new.project.id)
      flash[:notice] = "親タスクの新規作成に成功しました。"
    else
      flash.now[:alert] = "親タスクの新規作成に失敗しました。"
      render :new
    end
  end

  def show
    @parent_task = ParentTask.find(params[:id])
  end

  def edit
    @parent_task = ParentTask.find(params[:id])
  end

  def update
    @parent_task = ParentTask.find(params[:id])
    if @parent_task.update(parent_task_params)
      redirect_to project_path(@parent_task.project.id)
      flash[:notice] = "親タスクの更新に成功しました。"
    else
      flash.now[:alert] = "親タスクの更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @parent_task = ParentTask.find(params[:id])
    project = @parent_task.project
    if @parent_task.destroy
      project.have_parent_task_display_number_again
      redirect_to project_path(project.id)
      flash[:notice] = "親タスクの削除に成功しました。"
    else
      flash.now[:alert] = "親タスクの削除に失敗しました。"
      render :show
    end
  end

  def bulk_new
    default_parent_task_count = 5
    @project = Project.find(params[:project_id])
    @parent_task_bulk_new = default_parent_task_count.times.map { ParentTask.new }
  end

  def bulk_create
    @project = Project.find(params[:project_id])
    @parent_task_bulk_new = parent_task_require
    success_count = 0
    failure_count = 0

    @parent_task_bulk_new.each do |value|
      parent_task_new = ParentTask.new(parent_task_permit(value))
      if parent_task_new.title.present?
        parent_task_new.project_id = @project.id
        parent_task_new.display_order = @project.have_parent_task_get_max_display_order

        if parent_task_new.save
          success_count += 1
        else
          failure_count += 1
        end
      end
    end

    redirect_to project_path(@project.id)

    if success_count > 0
      flash[:notice] = "#{success_count}件の親タスクの新規作成に成功しました。"
    end

    if failure_count > 0
      flash[:alert] = "#{failure_count}件の親タスクの新規作成に失敗しました。"
    end

  end

  def bulk_edit
    @project = Project.find(params[:project_id])
  end

  def bulk_update
    @project = Project.find(params[:project_id])
    @parent_task_bulk = parent_task_require
    success_count = 0
    failure_count = 0

    @parent_task_bulk.each do |key,value|
      parent_task = ParentTask.find(key)
      if parent_task.update(parent_task_permit(value))
        success_count += 1
      else
        failure_count += 1
      end
    end

    redirect_to project_path(@project.id)

    if success_count > 0
      flash[:notice] = "#{success_count}件の親タスクの更新に成功しました。"
    end

    if failure_count > 0
      flash[:alert] = "#{failure_count}件の親タスクの更新に失敗しました。"
    end

  end

  def bulk_delete
    @project = Project.find(params[:project_id])
  end

  def bulk_destroy
    @project = Project.find(params[:project_id])
    checked_data = params[:deletes]
    success_count = 0
    display_order_num = 0

    checked_data.each do |key,value|
      if value.to_i == 1
        ParentTask.find(key).destroy
        success_count += 1
      end
    end

    if success_count > 0
      @project.have_parent_task_display_number_again
      redirect_to project_path(@project.id)
      flash[:notice] = "#{success_count}件の親タスクの削除に成功しました。"
    else
      flash.now[:alert] = "親タスクの削除に失敗しました。"
      render :bulk_delete
    end
  end

  private

  def parent_task_params
    params.require(:parent_task).permit(:project_id, :title, :description, :display_order)
  end

  def parent_task_require
    params.require(:parent_task)
  end

  def parent_task_permit(value)
    value.permit(:project_id, :title, :description, :display_order)
  end

  def ensure_project_member
      user = User.find(current_user.id)
      project = Project.find(params[:project_id])
      project_member = ProjectMember.find_by(project_id: project.id, user_id: user.id)
    unless ProjectMember.permissions[project_member.permission] >= 10
      redirect_to project_path(project.id)
      flash[:alert] = "タスクの追加や編集には編集権限、または管理者権限が必要です。"
    end
  end

end
