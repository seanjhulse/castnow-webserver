class UsersController < ApplicationController
  before_action :authenticate, except: [:index, :new, :create, :login]
  before_action :set_user, except: [:index, :new, :create, :logout]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:current_user_id] = @user.id
      redirect_to root_path
    else
      redirect_back fallback_location: root_path
    end
  end

  def update
    if @user.update(user_params)
      redirect_to root_path
    else
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    session[:current_user_id] = nil
    @user.destroy
  end

  def login
    session[:current_user_id] = @user.id
    redirect_to root_path
  end

  def logout
    session[:current_user_id] = nil
    redirect_to users_path
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:id, :name, :videos_path)
  end
end
