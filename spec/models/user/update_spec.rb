require 'rails_helper'

RSpec.describe User, type: :model do
  it 'will update a valid user with valid attributes' do
    user = FactoryBot.create(:user)
    new_attributes = FactoryBot.attributes_for(:user)

    user.update(new_attributes)

    expect(user.email).to eq(new_attributes[:email])
    expect(user.username).to eq(new_attributes[:username])
    expect(user.username).to eq(new_attributes[:username])
    expect(user.detail.first_names).to eq(new_attributes[:detail_attributes][:first_names])
    expect(user.detail.last_names).to eq(new_attributes[:detail_attributes][:last_names])
    expect(user.detail.birth_date).to eq(new_attributes[:detail_attributes][:birth_date])
    expect(user.detail.address).to eq(new_attributes[:detail_attributes][:address])
    expect(user.detail.personal_phone).to eq(new_attributes[:detail_attributes][:personal_phone])
    expect(user.detail.emergency_phone).to eq(new_attributes[:detail_attributes][:emergency_phone])
  end

  it 'wont update a valid user with the email of another existing user' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    original_email = user1.email

    user1.update(email: user2.email)
    user1.reload
    expect(user1.email).to eq(original_email)
  end

  it 'wont update a valid user with the username of another existing user' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    original_username = user1.username

    user1.update(username: user2.username)
    user1.reload
    expect(user1.username).to eq(original_username)
  end

  it 'wont update a valid user with an empty username' do
    user = FactoryBot.create(:user)
    original_username = user.username

    user.update(username: nil)
    user.reload
    expect(user.username).to eq(original_username)
  end

  it 'wont update a valid user with an empty email' do
    user = FactoryBot.create(:user)
    original_email = user.email

    user.update(email: nil)
    user.reload
    expect(user.email).to eq(original_email)
  end

  it 'wont update a valid user with mismatching passwords' do
    user = FactoryBot.create(:user)
    original_password = user.encrypted_password

    user.update(password: Devise.friendly_token, password_confirmation: Devise.friendly_token)
    user.reload
    expect(user.encrypted_password).to eq(original_password)
  end
end
