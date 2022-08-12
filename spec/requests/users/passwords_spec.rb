require 'rails_helper'

RSpec.describe 'Users::Passwords', type: :request do
  describe 'POST /password' do
    it 'is valid because there is a user with the requested username' do
      user = FactoryBot.create(:user)

      user_credentials = { username: user.username }
      post('/password', params: { user: user_credentials })

      expect_http_ok
    end

    it 'is valid because there is a user with the requested email' do
      user = FactoryBot.create(:user)

      user_credentials = { username: user.email }
      post('/password', params: { user: user_credentials })

      expect_http_ok
    end

    it 'is invalid because there is no user with the requested username or email' do
      user_credentials = { username: Faker::Internet.username }
      post('/password', params: { user: user_credentials })

      expect_http_bad_request
    end
  end

  describe 'PUT /password' do
    it 'is valid because there is an active reset password token' do
      user = FactoryBot.create(:user)
      token = generate_reset_password_token(user)
      new_password = Devise.friendly_token

      user_credentials = { password: new_password, password_confirmation: new_password, reset_password_token: token }

      put('/password', params: { user: user_credentials })

      expect_http_ok
    end

    it 'is invalid because no reset password token matches the one provided' do
      user = FactoryBot.create(:user)
      generate_reset_password_token(user)
      token = Devise.friendly_token
      new_password = Devise.friendly_token

      user_credentials = { password: new_password, password_confirmation: new_password, reset_password_token: token }

      put('/password', params: { user: user_credentials })

      response_object = expect_http_bad_request

      message1 = I18n.t('activerecord.attributes.user.reset_password_token')
      message2 = I18n.t('activerecord.errors.models.user.attributes.reset_password_token.invalid')
      error_message = "#{message1} #{message2}"

      expect(response_object['error']['message']).to eq(error_message)
    end

    it 'is invalid because no rest password token is provided' do
      user = FactoryBot.create(:user)
      generate_reset_password_token(user)
      new_password = Devise.friendly_token

      user_credentials = { password: new_password, password_confirmation: new_password }

      put('/password', params: { user: user_credentials })

      response_object = expect_http_bad_request

      message1 = I18n.t('activerecord.attributes.user.reset_password_token')
      message2 = I18n.t('activerecord.errors.models.user.attributes.reset_password_token.invalid')
      error_message = "#{message1} #{message2}"

      expect(response_object['error']['message']).to eq(error_message)
    end

    it 'is invalid because the provided passwords dont match' do
      user = FactoryBot.create(:user)
      token = generate_reset_password_token(user)
      new_password = Devise.friendly_token
      new_password2 = Devise.friendly_token

      user_credentials = { password: new_password, password_confirmation: new_password2, reset_password_token: token }

      put('/password', params: { user: user_credentials })

      response_object = expect_http_bad_request

      message1 = I18n.t('activerecord.attributes.user.password_confirmation')
      message2 = I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')
      error_message = "#{message1} #{message2}"

      expect(response_object['error']['message']).to eq(error_message)
    end
  end
end
