class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    authenticate_with_open_id(params[:openid_identity], :optional => [:nickname,:postcode,:timezone]) do |result, openid_identity, registration|
      if result.successful?
        user = User.openid_registration(openid_identity, registration)
        if user.save
          session[:user_id] = user.id
        end
      else
        flash[:warning] = result.message
      end
      redirect_to root_url
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
