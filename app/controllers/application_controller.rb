class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    if session[:current_user_id]
      User.find(session[:current_user_id])
    else
      nil
    end
  end

  private
  def authenticate
    if current_user
      redirect_to root_path
    end

    redirect_to users_path
  end
end
