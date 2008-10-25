class OpenidsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :show
  before_filter :ensure_logged_in

  def show
    authenticate_with_open_id(current_user.new_openid_identity) do |result, openid_identity|
      if result.successful?
        unless current_user.update_attributes(:openid_identity => openid_identity,
                                              :new_openid_identity => nil)
          flash[:warning] = current_user.errors.full_messages.join(', ')
        end
      else
        flash[:warning] = result.message
      end
      redirect_to edit_account_path
    end
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to show_openid_path
    else
      flash[:warning] = current_user.errors.full_messages.join(', ')
      redirect_to edit_account_path
    end
  end
end
