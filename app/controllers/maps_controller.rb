class MapsController < ApplicationController

  def index
    redirect_to @current_user
  end

  def show
    redirect_to @current_user
  end
  
  def new
   redirect_to @current_user


  end
  

  
  def create
    redirect_to @current_user
  end
end
