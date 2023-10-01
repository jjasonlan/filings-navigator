class FilersController < ApplicationController
  def index
    filers = Filer.all
    render json:filers
  end

  def show
    filer = Filer.find_by(ein: params[:ein])
    render json: filer
  end

end
