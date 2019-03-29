class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  before_action :authenticate, except: [:index, :new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
    @video_paths = ["/these/are/test/paths", "/pay/them/no/mind", "/home/sean/videos/"]
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:current_user_id] = @user.id
      redirect_to movies_path
    else
      flash[:notice] = @user.errors.messages
      redirect_back fallback_location: root_path
    end
  end

  def update
    @user.update(user_params)
  end

  def destroy
    session[:current_user_id] = nil
    @user.destroy
  end

  def login
    session[:current_user_id] = @user.id
  end

  def logout
    session[:current_user_id] = nil
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:id, :name, :videos_path)
  end
end
