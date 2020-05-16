class TasksController < ApplicationController
before_action :require_user_logged_in
before_action :correct_user, only: [:destroy]
    def index
        if logged_in?
            @tasks = current_user.tasks.order(id: :asc).page(params[:page])
        end
    end
    
    def show
        @task = current_user.tasks.find_by(id: params[:id])
    end
    
    def new
        @task = current_user.tasks.build
    end
    
    def create
        @task = current_user.tasks.build(task_params)
        if @task.save
            flash[:success]="タスクが保存されました。"
            redirect_to @task
        else
            flash.now[:danger]="保存に失敗しました。"
            render :new
        end
    end
    
    def edit
        @task = current_user.tasks.find_by(id: params[:id])
    end
    
    def update
        @task = current_user.tasks.find_by(id: params[:id])
        
        if @task.update(task_params)
            flash[:success] = "タスクを更新しました"
            redirect_to @task
        else
            flash.now[:danger]="タスク更新に失敗しました"
            render :edit
        end
    end
    
    def destroy
        @task.destroy
        flash[:success] ="タスクが削除されました"
        redirect_to tasks_url
    end
    
    private
    def task_params
        params.require(:task).permit(:content, :status)
    end
    
    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        unless @task
            redirect_to root_url
        end
    end
end
