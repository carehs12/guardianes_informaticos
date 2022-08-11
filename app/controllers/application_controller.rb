# Base parent controller that has all the basic functionality of the application
class ApplicationController < ActionController::Base
  include Responder::Json
  
  before_action :authenticate_user!, :set_theme

  def set_query_params
    @params = params.downcase

    @page = 1
    @page = params[:page].to_i if params[:page]

    @per_page = 15
    @per_page = params[:per_page].to_i if params[:per_page]
  end

  def set_theme
    @theme = current_user.detail.theme if user_signed_in?
  end
end
