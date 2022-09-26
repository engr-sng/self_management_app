class Public::ChildTasksController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_project_member, only: [:new, :create, :edit, :update, :destroy,:bulk_new, :bulk_create, :bulk_edit, :bulk_update, :bulk_delete, :bulk_destroy]

  def new
    @project = Project.find(params[:project_id])
    @child_task_new = ChildTask.new
  end

  def create
    @project = Project.find(params[:project_id])
    @child_task_new = ChildTask.new(child_task_params)
    @child_task_new.display_order = @child_task_new.parent_task.have_child_task_get_max_display_order

    if @child_task_new.save
      redirect_to project_path(@child_task_new.project.id)
      flash[:notice] = "子タスクの新規作成に成功しました。"
    else
      flash.now[:alert] = "子タスクの新規作成に失敗しました。"
      render :new
    end
  end

  def show
    @child_task = ChildTask.find(params[:id])
  end

  def edit
    @child_task = ChildTask.find(params[:id])
  end

  def update
    @child_task = ChildTask.find(params[:id])
    before_parent_task = @child_task.parent_task

    if @child_task.update(child_task_params)
      @child_task.update(progress: ChildTask.statuses[@child_task.status])
      after_parent_task = @child_task.parent_task
      if before_parent_task.id != after_parent_task.id
        @child_task.update(display_order: after_parent_task.have_child_task_get_max_display_order)
        before_parent_task.have_child_task_display_number_again
        after_parent_task.have_child_task_display_number_again
      end
      redirect_to project_path(@child_task.project.id)
      flash[:notice] = "子タスクの更新に成功しました。"
    else
      flash.now[:alert] = "子タスクの更新に失敗しました。"
      render :edit
    end
  end

  def select_update
    @project = Project.find(params[:project_id])
    @child_task = ChildTask.find(params[:id])
    @project_member = ProjectMember.find_by(project_id: @project.id, user_id: @child_task.user_id)
    @child_task.update(child_task_params)
    @child_task.update(progress: ChildTask.statuses[@child_task.status])
  end

  def destroy
    @child_task = ChildTask.find(params[:id])

    if @child_task.destroy
      @child_task.parent_task.have_child_task_display_number_again
      redirect_to project_path(@child_task.project.id)
      flash[:notice] = "子タスクの削除に成功しました。"
    else
      flash.now[:alert] = "子タスクの削除に失敗しました。"
      render :show
    end
  end

  def bulk_new
    default_child_task_count = 10
    @project = Project.find(params[:project_id])
    @child_task_bulk_new = default_child_task_count.times.map { ChildTask.new }
  end

  def bulk_create
    @project = Project.find(params[:project_id])
    @child_task_bulk_new = child_task_require
    success_count = 0
    failure_count = 0

    @child_task_bulk_new.each do |value|
      child_task_new = ChildTask.new(child_task_permit(value))
      child_task_new.display_order = child_task_new.parent_task.have_child_task_get_max_display_order
      if child_task_new.title.present?
        if child_task_new.save
          success_count += 1
        else
          failure_count += 1
        end
      end
    end

    redirect_to project_path(@project.id)

    if success_count > 0
      flash[:notice] = "#{success_count}件の子タスクの新規作成に成功しました。"
    end

    if failure_count > 0
      flash[:alert] = "#{failure_count}件の子タスクの新規作成に失敗しました。"
    end

  end

  def bulk_edit
    @project = Project.find(params[:project_id])
  end

  def bulk_update
    @project = Project.find(params[:project_id])
    @child_task_bulk = child_task_require
    success_count = 0
    failure_count = 0
    parent_task_change_count = 0

    @child_task_bulk.each do |key,value|
      child_task = ChildTask.find(key)
      before_parent_task = child_task.parent_task

      if child_task.update(child_task_permit(value))
        after_parent_task = child_task.parent_task
        if before_parent_task.id != after_parent_task.id
          child_task.update(display_order: after_parent_task.have_child_task_get_max_display_order)
          parent_task_change_count += 1
        end
        success_count += 1
      else
        failure_count += 1
      end
    end

    if parent_task_change_count > 0
      @project.parent_tasks.order(display_order: :ASC).each do |parent_task|
        parent_task.have_child_task_display_number_again
      end
    end

    redirect_to project_path(@project.id)

    if success_count > 0
      flash[:notice] = "#{success_count}件の子タスクの更新に成功しました。"
    end

    if failure_count > 0
      flash[:alert] = "#{failure_count}件の子タスクの更新に失敗しました。"
    end

  end


  def bulk_delete
    @project = Project.find(params[:project_id])
  end

  def bulk_destroy
    @project = Project.find(params[:project_id])
    checked_data = params[:deletes]
    success_count = 0

    checked_data.each do |key,value|
      if value.to_i == 1
        ChildTask.find(key).destroy
        success_count += 1
      end
    end

    if success_count > 0
      @project.parent_tasks.order(display_order: :ASC).each do |parent_task|
        parent_task.have_child_task_display_number_again
      end
      redirect_to project_path(@project.id)
      flash[:notice] = "#{success_count}件の子タスクの削除に成功しました。"
    else
      flash.now[:alert] = "子タスクの削除に失敗しました。"
      render :bulk_delete
    end
  end

  private

  def child_task_params
    params.require(:child_task).permit(:parent_task_id, :user_id, :title, :description, :start_date, :end_date, :status, :progress, :display_order)
  end

  def child_task_require
    params.require(:child_task)
  end

  def child_task_permit(value)
    value.permit(:parent_task_id, :user_id, :title, :description, :start_date, :end_date, :status, :progress, :display_order)
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
