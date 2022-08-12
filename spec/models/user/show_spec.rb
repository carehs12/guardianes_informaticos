require 'rails_helper'

RSpec.describe User, type: :model do
  it 'will show a valid user with all its detail fields' do
    user = FactoryBot.create(:user)

    user_data = user.show

    expect(user_data).to have_key(:email)
    expect(user_data).to have_key(:username)
    expect(user_data).to have_key(:profile_picture_src)
    expect(user_data).to have_key(:detail_attributes)
    expect(user_data[:detail_attributes]).to have_key('first_names')
    expect(user_data[:detail_attributes]).to have_key('last_names')
    expect(user_data[:detail_attributes]).to have_key('birth_date')
    expect(user_data[:detail_attributes]).to have_key('address')
    expect(user_data[:detail_attributes]).to have_key('personal_phone')
    expect(user_data[:detail_attributes]).to have_key('emergency_phone')
  end
end
