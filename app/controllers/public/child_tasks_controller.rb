class Public::ChildTasksController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_project_member, only: [:new, :create, :edit, :update, :destroy]

  def new
    @project = Project.find(params[:project_id])
    @child_task_new = ChildTask.new
  end

  def create
    @project = Project.find(params[:project_id])
    @child_task_new = ChildTask.new(child_task_params)
    @parent_task = ParentTask.find(@child_task_new.parent_task_id)

    if @parent_task.child_tasks.pluck(:display_order).max.nil?
      @child_task_new.display_order = 1
    else
      @child_task_new.display_order = (@parent_task.child_tasks.pluck(:display_order).max + 1)
    end

    if @child_task_new.save
      redirect_to project_path(@child_task_new.project.id)
      flash[:notice] = "子タスクの新規作成に成功しました。"
    else
      flash[:alert] = "子タスクの新規作成に失敗しました。"
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
    before_display_order_num = 0
    after_display_order_num = 0
    if @child_task.update(child_task_params)
      @child_task.update(progress: ChildTask.statuses[@child_task.status])
      after_parent_task = @child_task.parent_task
      if before_parent_task.id != after_parent_task.id
        before_parent_task.child_tasks.order(display_order: :ASC).each do |child_task|
          before_display_order_num += 1
          child_task.update(display_order: before_display_order_num)
        end

        if after_parent_task.child_tasks.pluck(:display_order).max.nil?
          @child_task.update(display_order: 1)
        else
          display_order_max = (after_parent_task.child_tasks.pluck(:display_order).max + 1)
          @child_task.update(display_order: display_order_max)
        end

        after_parent_task.child_tasks.order(display_order: :ASC).each do |child_task|
          after_display_order_num += 1
          child_task.update(display_order: after_display_order_num)
        end
      end

      redirect_to project_path(@child_task.project.id)
      flash[:notice] = "子タスクの更新に成功しました。"
    else
      flash[:alert] = "子タスクの更新に失敗しました。"
      render :edit
    end
  end

  def select_update
    @project = Project.find(params[:project_id])
    @child_task = ChildTask.find(params[:id])
    @child_task.update(child_task_params)
    @child_task.update(progress: ChildTask.statuses[@child_task.status])
  end

  def destroy
    @child_task = ChildTask.find(params[:id])
    @parent_task = @child_task.parent_task
    display_order_num = 0
    if @child_task.destroy
      @parent_task.child_tasks.order(display_order: :ASC).each do |child_task|
        display_order_num += 1
        child_task.update(display_order: display_order_num)
      end
      redirect_to project_path(@child_task.project.id)
      flash[:notice] = "子タスクの削除に成功しました。"
    else
      flash[:alert] = "子タスクの削除に失敗しました。"
      render :show
    end
  end

  private

  def child_task_params
    params.require(:child_task).permit(:parent_task_id,:user_id,:title,:description,:start_date,:end_date,:status,:progress,:display_order)
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
