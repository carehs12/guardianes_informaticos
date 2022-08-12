require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user)

    expect(user.id).not_to eq(nil)
    expect(user.detail).not_to eq(nil)
    expect(user.detail.id).not_to eq(nil)
    expect(user.encrypted_password).to be_a_kind_of(String)
  end

  it 'is valid with minimum attributes' do
    attributes = FactoryBot.attributes_for(:user)
    attributes[:detail_attributes] = {}
    user = User.create(attributes)

    expect(user.id).not_to eq(nil)
    expect(user.detail).not_to eq(nil)
    expect(user.detail.id).not_to eq(nil)
    expect(user.encrypted_password).to be_a_kind_of(String)
  end

  it 'is invalid because password confirmation doesnt match' do
    attributes = FactoryBot.attributes_for(:user)
    attributes[:password_confirmation] = Devise.friendly_token

    user = User.create(attributes)
    message1 = I18n.t('activerecord.attributes.user.password_confirmation')
    message2 = I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')
    error_message = "#{message1} #{message2}"

    expect(user.id).to eq(nil)
    expect(user.errors.full_messages.to_sentence).to eq(error_message)
  end

  it 'is invalid because no email is provided' do
    attributes = FactoryBot.attributes_for(:user)
    attributes[:email] = nil

    user = User.create(attributes)
    message1 = I18n.t('activerecord.attributes.user.email')
    message2 = I18n.t('activerecord.errors.models.user.attributes.email.blank')
    error_message = "#{message1} #{message2}"

    expect(user.id).to eq(nil)
    expect(user.errors.full_messages.to_sentence).to eq(error_message)
  end

  it 'is invalid because no username is provided' do
    attributes = FactoryBot.attributes_for(:user)
    attributes[:username] = nil

    user = User.create(attributes)
    message1 = I18n.t('activerecord.attributes.user.username')
    message2 = I18n.t('activerecord.errors.models.user.attributes.username.blank')
    error_message = "#{message1} #{message2}"

    expect(user.id).to eq(nil)
    expect(user.errors.full_messages.to_sentence).to eq(error_message)
  end

  it 'is invalid because the email is already taken' do
    user = FactoryBot.create(:user)

    attributes = FactoryBot.attributes_for(:user)
    attributes[:email] = user.email

    new_user = User.create(attributes)
    message1 = I18n.t('activerecord.attributes.user.email')
    message2 = I18n.t('activerecord.errors.models.user.attributes.email.taken')
    error_message = "#{message1} #{message2}"

    expect(new_user.id).to eq(nil)
    expect(new_user.errors.full_messages.to_sentence).to eq(error_message)
  end

  it 'is invalid because the username is already taken' do
    user = FactoryBot.create(:user)

    attributes = FactoryBot.attributes_for(:user)
    attributes[:username] = user.username

    new_user = User.create(attributes)
    message1 = I18n.t('activerecord.attributes.user.username')
    message2 = I18n.t('activerecord.errors.models.user.attributes.username.taken')
    error_message = "#{message1} #{message2}"

    expect(new_user.id).to eq(nil)
    expect(new_user.errors.full_messages.to_sentence).to eq(error_message)
  end
end
