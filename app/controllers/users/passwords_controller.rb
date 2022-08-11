module Users
  # Manages password reset for the platform
  class PasswordsController < Devise::PasswordsController
    include Responder::Json

    before_action :set_user, only: :create

    # POST /password
    def create
      return respond_http_bad_request(t('.invalid_username_or_emal')) unless @user

      params[:user][:email] = @user.email

      super do |resource|
        return respond_http_ok({ email: obscured_user_email }) if successfully_sent?(resource)

        return respond_http_bad_request(resource.errors.full_messages.to_sentence)
      end
    end

    # PUT /password
    def update
      super do |user|
        if user.errors.empty?
          bypass_sign_in(user)
          return respond_http_ok
        end

        return respond_http_bad_request(user.errors.full_messages.to_sentence)
      end
    end

    private

    # @return [String] A string with the majority of the email address obscured
    # @description Takes the email of @user and replaces most of the letter with
    #   asterisks, so it is obscured
    def obscured_user_email
      email_parts = @user.email.split('@')
      receipt_email = email_parts[0].chars.map.with_index do |char, index|
        index < 2 ? char : '*'
      end
      "#{receipt_email.join}@#{email_parts[1]}"
    end

    def set_user
      @user = nil
      return unless params[:user]

      @user = User.find_by(username: params[:user][:username])
      @user = User.find_by(email: params[:user][:username]) if @user.nil?
    end
  end
end
