class SubscriptionsController < ApplicationController
  before_filter :ensure_logged_in

  def create
    user = User.find(params[:user_id])
    subscription = Subscription.new(:user => user,
                                    :subscriber => current_user)
    subscription.save
    flash[:success] = "You are now subscribed to #{user.nickname}."
    redirect_to user
  end

  def destroy
    user = User.find(params[:user_id])
    Subscription.destroy_all(:user_id => user.to_param,
                             :subscriber_id => current_user.to_param)
    flash[:success] = "You have unsubscribed."
    redirect_to user
  end
end
