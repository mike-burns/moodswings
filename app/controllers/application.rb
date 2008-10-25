class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  include ApplicationHelper
  include HoptoadNotifier::Catcher

  private

  def ensure_logged_in
    unless logged_in?
      flash[:warning] = 'Must be signed in'
      redirect_to root_url
    end
  end
end
