class PagesController < ApplicationController
  def show
    render :template => "pages/#{params[:name]}"
  end 

  def home
    render :layout => false
  end 
end
