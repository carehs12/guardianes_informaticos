module Users
  # Manages user authentication for the platform
  class SessionsController < Devise::SessionsController
    include Responder::Json

    before_action :set_locales_source

    # POST /login
    def create
      resource = User.find_for_database_authentication(username: sign_in_params[:username])

      return respond_http_bad_request(t('.incorrect_username_or_password')) unless resource
      return respond_http_bad_request(t('.incorrect_username_or_password')) if resource.deleted_at

      unless resource.valid_password?(sign_in_params[:password])
        return respond_http_bad_request(t('.incorrect_username_or_password'))
      end

      sign_in(:user, resource)
      respond_http_ok
    end

    private

    def set_locales_source
      I18n.t 'controllers.sessions'
    end

    def sign_in_params
      params.fetch(
        :user, {}
      ).permit(
        :username,
        :password
      )
    end
  end
end
