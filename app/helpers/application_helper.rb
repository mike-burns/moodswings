module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
end
