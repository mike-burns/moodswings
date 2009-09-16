class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  include ApplicationHelper
  include HoptoadNotifier::Catcher

  protected

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def ensure_logged_in
    unless logged_in?
      flash[:warning] = 'Must be signed in'
      redirect_to root_url
    end
  end
end
