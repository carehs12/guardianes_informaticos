# Allows a user to create and manage other users through HTTP
class UsersController < ApplicationAuthenticatedController
  before_action :generate_password, only: %i[create]
  before_action :set_user, only: %i[update destroy]

  def index
    respond_to do |format|
      format.json do
        set_query_params # Defined in application_controller
        users = User.index(@page, @per_page, @query)

        respond_http_ok(users)
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        user = User.create(user_params)
        if user.persisted?
          respond_http_ok(user.show)
        else
          respond_http_bad_request(user.errors.full_messages.to_sentence)
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        set_user
        return respond_http_not_found unless @user

        respond_http_ok(@user.show)
      end
    end
  end

  def update
    return respond_http_not_found unless @user

    if @user.update(user_params)
      respond_http_ok(@user.show)
    else
      respond_http_bad_request(@user.errors.full_messages.to_sentence)
    end
  end

  def destroy
    return respond_http_not_found unless @user

    if @user.destroy
      respond_http_ok
    else
      respond_http_bad_request(@user.errors.full_messages.to_sentence)
    end
  end

  private

  def generate_password
    return if params[:user][:password] && params[:user][:password_confirmation]

    password = Devise.friendly_token
    params[:user][:password] = password
    params[:user][:password_confirmation] = password
  end

  def user_params
    params.fetch(:user, {}).permit(
      :email,
      :username,
      :password,
      :password_confirmation,
      :profile_picture,
      detail_attributes: detail_attributes_params
    )
  end

  def detail_attributes_params
    %i[
      theme
      first_names
      last_names
      personal_phone
      emergency_phone
      birth_date
      address
    ]
  end

  def set_user
    @user = User.find_by_id(params[:id])
  end
end
