require 'rails_helper'

RSpec.describe User, type: :model do
  it 'will return a list of users and the total count' do
    FactoryBot.create_list(:user, 15)
    user_list = User.index(nil, 0, 15)

    expect(user_list).to have_key(:total_records)
    expect(user_list).to have_key(:records)
    expect(user_list[:total_records]).to be >= 15
    expect(user_list[:records].size).to eql(15)
  end

  it 'will filter users based on a given text by email' do
    user_attributes = FactoryBot.attributes_for(:user)
    User.create!(user_attributes)

    FactoryBot.create_list(:user, 9)
    user_list = User.index(user_attributes['email'], 0, 10)

    expect(user_list).to have_key(:records)
    expect(user_list[:records].size).to be >= 1
  end

  it 'will filter users based on a given text by username' do
    user_attributes = FactoryBot.attributes_for(:user)
    User.create!(user_attributes)

    FactoryBot.create_list(:user, 9)
    user_list = User.index(user_attributes['username'], 0, 10)

    expect(user_list).to have_key(:records)
    expect(user_list[:records].size).to be >= 1
  end

  it 'will filter users based on a given text by first names' do
    user_attributes = FactoryBot.attributes_for(:user)
    User.create!(user_attributes)

    FactoryBot.create_list(:user, 9)
    user_list = User.index(user_attributes[:detail_attributes]['first_names'], 0, 10)

    expect(user_list).to have_key(:records)
    expect(user_list[:records].size).to be >= 1
  end

  it 'will filter users based on a given text by last names' do
    user_attributes = FactoryBot.attributes_for(:user)
    User.create!(user_attributes)

    FactoryBot.create_list(:user, 9)
    user_list = User.index(user_attributes[:detail_attributes]['last_names'], 0, 10)

    expect(user_list).to have_key(:records)
    expect(user_list[:records].size).to be >= 1
  end

  it 'will paginate the response, even if no pagination values are given' do
    FactoryBot.create_list(:user, 30)
    user_list = User.index

    expect(user_list).to have_key(:total_records)
    expect(user_list).to have_key(:records)
    expect(user_list[:total_records]).to be >= 30
    expect(user_list[:records].size).to be <= 25
  end
end
