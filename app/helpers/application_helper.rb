module ApplicationHelper
	'''
    Grabs the current user from the session_id. No authentication required yet
    because its all local host
  '''
	def current_user
    if session[:current_user_id]
      User.find(session[:current_user_id])
    else
      nil
    end
  end
end
