class MoodsController < ApplicationController
  before_filter :ensure_logged_in

  def create
    mood = current_user.moods.build(:x => params[:x],
                                    :y => params[:y])
    mood.save
    redirect_to user_path(current_user)
  end

  def destroy
    mood = current_user.moods.find(params[:id])
    mood.destroy
    redirect_to user_path(current_user)
  end
end
