class Public::ChildTasksController < ApplicationController

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
    @change_before_parent_task = @child_task.parent_task
    display_order_num = 0
    if @child_task.update(child_task_params)
      @child_task.update(progress: ChildTask.statuses[@child_task.status])
      @change_after_parent_task = @child_task.parent_task
      if @change_before_parent_task.id != @change_after_parent_task.id
        @change_before_parent_task.child_tasks.order(display_order: :ASC).each do |child_task|
          display_order_num += 1
          child_task.update(display_order: display_order_num)
        end

        if @change_after_parent_task.child_tasks.pluck(:display_order).max.nil?
          @child_task.update(display_order: 1)
        else
          display_order_max = (@change_after_parent_task.child_tasks.pluck(:display_order).max + 1)
          @child_task.update(display_order: display_order_max)
        end
      end
      redirect_to project_path(@child_task.project.id)
      flash[:notice] = "子タスクの更新に成功しました。"
    else
      flash[:alert] = "子タスクの更新に失敗しました。"
      render :edit
    end
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

end
