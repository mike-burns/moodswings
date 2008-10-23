class AccountsController < ApplicationController
  before_filter :ensure_logged_in

  def edit
  end

  private

  def ensure_logged_in
    unless logged_in?
      flash[:warning] = 'Must be signed in'
      redirect_to root_url
    end
  end
end
