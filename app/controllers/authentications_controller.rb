# Controller to manage the authentication process
class AuthenticationsController < ApplicationController
  skip_before_action :authenticate_user!

  def show() end
end
