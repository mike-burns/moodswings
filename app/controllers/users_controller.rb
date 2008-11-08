class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @moods = @user.moods.first(10)
  end
end
