require 'rails_helper'

RSpec.describe User, type: :model do
  it 'deletes a valid user' do
    user = FactoryBot.create(:user)

    user.destroy

    expect(User.find_by_id(user.id)).to eq(nil)
    expect(User.find_by(email: user.email)).to eq(nil)
  end

  it 'fails to delete a user that is assigned to a schedule' do
    expect(true).to eq(false)
  end
end
