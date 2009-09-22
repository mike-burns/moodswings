class PagesController < ApplicationController
  def show
    render :template => "pages/#{params[:name]}"
  end 

  def home
    logged_in? ?
      redirect_to( home_path ) : render( :layout => false )
  end 
  
  def dashboard
    return redirect_to :action => :home unless logged_in?
    
    @theme = "sunset"
  end
end
