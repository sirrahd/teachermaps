class MapsController < ApplicationController
  include SessionsHelper

  def index
    redirect_to root_path
  end

  def show
    redirect_to root_path
  end
  
  def new
   redirect_to root_path
  end

  def edit
   redirect_to root_path
  end
  
  def create
    redirect_to root_path
  end

  def update
   redirect_to root_path
  end

  def destroy
   redirect_to root_path
  end
end
