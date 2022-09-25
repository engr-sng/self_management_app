class Public::ParentTasksController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_project_member, only: [:new, :create, :edit, :update, :destroy]

  def new
    @project = Project.find(params[:project_id])
    @parent_task_new = ParentTask.new
  end

  def create
    @project = Project.find(params[:project_id])
    @parent_task_new = ParentTask.new(parent_task_params)
    @parent_task_new.project_id = @project.id

    if @project.parent_tasks.pluck(:display_order).max.nil?
      @parent_task_new.display_order = 1
    else
      @parent_task_new.display_order = (@project.parent_tasks.pluck(:display_order).max + 1)
    end

    if @parent_task_new.save
      redirect_to project_path(@parent_task_new.project.id)
      flash[:notice] = "親タスクの新規作成に成功しました。"
    else
      flash[:alert] = "親タスクの新規作成に失敗しました。"
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
      flash[:alert] = "親の更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @parent_task = ParentTask.find(params[:id])
    @project = @parent_task.project
    display_order_num = 0
    if @parent_task.destroy
      @project.parent_tasks.order(display_order: :ASC).each do |parent_task|
        display_order_num += 1
        parent_task.update(display_order: display_order_num)
      end
      redirect_to project_path(@parent_task.project.id)
      flash[:notice] = "親タスクの削除に成功しました。"
    else
      flash[:alert] = "親タスクの削除に失敗しました。"
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
    @parent_task_bulk_new = params.require(:parent_task)
    save_count = 0
    failure_count = 0

    @parent_task_bulk_new.each do |value|
      parent_task_new = ParentTask.new(value.permit(:title,:description))
      if parent_task_new.title.present?
        parent_task_new.project_id = @project.id
        if @project.parent_tasks.pluck(:display_order).max.nil?
          parent_task_new.display_order = 1
        else
          parent_task_new.display_order = (@project.parent_tasks.pluck(:display_order).max + 1)
        end

        if parent_task_new.save
          save_count += 1
        else
          failure_count += 1
        end
      end
    end

    redirect_to project_path(@project.id)

    if save_count > 0
      flash[:notice] = "#{save_count}件の親タスクの一括新規作成に成功しました。"
    end

    if failure_count > 0
      flash[:alert] = "#{failure_count}件の親タスクの一括新規作成に失敗しました。"
    end

  end

  def bulk_delete
    @project = Project.find(params[:project_id])
  end

  def bulk_destroy
    @project = Project.find(params[:project_id])
    checked_data = params[:deletes]
    destroy_count = 0
    display_order_num = 0

    checked_data.each do |key,value|
      if value.to_i == 1
        ParentTask.find(key).destroy
        destroy_count += 1
      end
    end

    if destroy_count > 0
      @project.parent_tasks.order(display_order: :ASC).each do |parent_task|
        display_order_num += 1
        parent_task.update(display_order: display_order_num)
      end
      redirect_to project_path(@project.id)
      flash[:notice] = "#{destroy_count}件の親タスクの削除に成功しました。"
    else
      flash[:alert] = "親タスクの削除に失敗しました。"
      render :bulk_delete
    end
  end

  private

  def parent_task_params
    params.require(:parent_task).permit(:project_id,:title,:description,:display_order)
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
