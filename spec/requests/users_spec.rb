require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    include_context 'authenticate user'

    it 'returns a list of existing users with pagination' do
      FactoryBot.create_list(:user, 15)
      get('/users.json')

      response_object = expect_http_ok
      expect(response_object).to have_key('data')
      expect(response_object['data']).to have_key('total_records')
      expect(response_object['data']).to have_key('records')
      expect(response_object['data']['records'].size).to be > 0
    end

    it 'returns the requested amount of records' do
      FactoryBot.create_list(:user, 5)
      get('/users.json', params: { per_page: 2 })

      response_object = expect_http_ok
      expect(response_object['data']['total_records']).to be > 2
      expect(response_object['data']['records'].size).to be 2
    end
  end

  describe 'POST /users' do
    include_context 'authenticate user'

    it 'creates a user with valid information' do
      user_attributes = FactoryBot.attributes_for(:user)
      post('/users.json', params: { user: user_attributes })

      response_object = expect_http_ok
      expect(response_object['data']).to have_key('id')
      expect(response_object['data']['email']).to eq(user_attributes[:email])
      expect(response_object['data']['username']).to eq(user_attributes[:username])
    end

    it 'creates a user even without password specified' do
      user_attributes = FactoryBot.attributes_for(:user)
      user_attributes.except!(:password, :password_confirmation)
      post('/users.json', params: { user: user_attributes })

      response_object = expect_http_ok
      expect(response_object['data']).to have_key('id')
    end

    it 'fails to create a user with duplicated email' do
      user = FactoryBot.create(:user)
      user_attributes = FactoryBot.attributes_for(:user)
      user_attributes[:email] = user.email

      post('/users.json', params: { user: user_attributes })

      response_object = expect_http_bad_request
      message1 = I18n.t('activerecord.attributes.user.email')
      message2 = I18n.t('activerecord.errors.models.user.attributes.email.taken')
      error_message = "#{message1} #{message2}"
      expect(response_object['error']['message']).to eq(error_message)
    end

    it 'fails to create a user with duplicated username' do
      user = FactoryBot.create(:user)
      user_attributes = FactoryBot.attributes_for(:user)
      user_attributes[:username] = user.username

      post('/users.json', params: { user: user_attributes })

      response_object = expect_http_bad_request
      message1 = I18n.t('activerecord.attributes.user.username')
      message2 = I18n.t('activerecord.errors.models.user.attributes.username.taken')
      error_message = "#{message1} #{message2}"
      expect(response_object['error']['message']).to eq(error_message)
    end
  end

  describe 'GET /users/:id' do
    include_context 'authenticate user'

    it 'returns the data of an existing user' do
      user = FactoryBot.create(:user)
      get("/users/#{user.id}.json")

      response_object = expect_http_ok
      expect(response_object['data']['id']).to eq(user.id)
      expect(response_object['data']['email']).to eq(user.email)
      expect(response_object['data']['username']).to eq(user.username)
    end

    it 'returns not found when the id of the user is invalid' do
      undefined_id = (User.last ? User.last.id + 1 : 1)
      get("/users/#{undefined_id}.json")

      expect_http_not_found
    end
  end

  describe 'PUT /users/:id' do
    include_context 'authenticate user'

    it 'modifies the data of an existing user' do
      user = FactoryBot.create(:user)
      user_attributes = FactoryBot.attributes_for(:user)
      put("/users/#{user.id}.json", params: { user: user_attributes })

      response_object = expect_http_ok
      response_data = response_object['data']
      response_detail = response_data['detail_attributes']
      expect(response_data['id']).to eq(user.id)
      expect(response_data['email']).to eq(user_attributes[:email])
      expect(response_data['username']).to eq(user_attributes[:username])
      expect(response_detail['first_names']).to eq(user_attributes[:detail_attributes][:first_names])
      expect(response_detail['last_names']).to eq(user_attributes[:detail_attributes][:last_names])
    end

    it 'returns not found when the id of the user is invalid' do
      undefined_id = (User.last ? User.last.id + 1 : 1)
      user_attributes = FactoryBot.attributes_for(:user)
      put("/users/#{undefined_id}.json", params: { user: user_attributes })

      expect_http_not_found
    end
  end

  describe 'DELETE /users/:id' do
    include_context 'authenticate user'

    it 'deletes the data of an existing user' do
      user = FactoryBot.create(:user)
      delete("/users/#{user.id}.json")

      expect_http_ok
    end

    it 'returns not found when the id of the user is invalid' do
      undefined_id = (User.last ? User.last.id + 1 : 1)
      user_attributes = FactoryBot.attributes_for(:user)
      delete("/users/#{undefined_id}.json", params: { user: user_attributes })

      expect_http_not_found
    end
  end
end
