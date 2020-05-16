class UsersController < ApplicationController
before_action :require_user_logged_in, only: [:show, :edit]
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user= User.new(user_params)
    email=@user.email
    password=@user.password
    if @user.save
      flash[:success]="ユーザを登録/ログインしました。"
      login(email, password)
      redirect_to root_path
    else
      flash.now[:danger]="ユーザの登録に失敗しました。"
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    
    if @user.update(user_params)
      flash[:success] = "ユーザ情報を更新しました"
        redirect_to @user
      else
        flash.now[:danger]="ユーザ情報の更新に失敗しました"
      render :edit
    end
    

  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def login(email, password)
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id
      return true
    else
      return false
    end
  end
  
end

