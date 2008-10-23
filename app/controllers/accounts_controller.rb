class AccountsController < ApplicationController
  before_filter :ensure_logged_in

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      flash[:notice] = 'We have updated your profile'
    else
      flash[:warning] = current_user.errors.full_messages.join(',')
    end
    redirect_to edit_account_path
  end

  private

  def ensure_logged_in
    unless logged_in?
      flash[:warning] = 'Must be signed in'
      redirect_to root_url
    end
  end
end
