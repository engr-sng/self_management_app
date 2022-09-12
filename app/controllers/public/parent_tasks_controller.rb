class Public::ParentTasksController < ApplicationController

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

  private

  def parent_task_params
    params.require(:parent_task).permit(:project_id,:title,:description,:display_order)
  end


end
