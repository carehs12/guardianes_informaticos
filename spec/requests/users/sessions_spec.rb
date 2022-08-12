require 'rails_helper'
require './spec/support/helpers/response_helper'

RSpec.configure do |config|
  config.include ResponseHelper
end

RSpec.describe 'Users::Sessions', type: :request do
  describe 'POST /login' do
    it 'is valid because the credentials are valid' do
      user_attributes = FactoryBot.attributes_for(:user)
      User.create(user_attributes)

      user_credentials = { username: user_attributes[:username], password: user_attributes[:password] }
      post('/login', params: { session: user_credentials })

      expect_http_ok
    end

    it 'is invalid because the username is wrong' do
      user_attributes = FactoryBot.attributes_for(:user)
      User.create(user_attributes)

      user_credentials = { username: Faker::Internet.username, password: user_attributes[:password] }
      post('/login', params: { session: user_credentials })

      response_object = respond_http_bad_request
      expect(response_object['error']['message']).to eq(I18n.t('users.sessions.create.incorrect_username_or_password'))
    end

    it 'is invalid because the password is wrong' do
      user_attributes = FactoryBot.attributes_for(:user)
      User.create(user_attributes)

      user_credentials = { username: user_attributes[:username], password: Devise.friendly_token }
      post('/login', params: { session: user_credentials })

      response_object = respond_http_bad_request
      expect(response_object['error']['message']).to eq(I18n.t('users.sessions.create.incorrect_username_or_password'))
    end
  end
end
