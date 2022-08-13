require 'rails_helper'

RSpec.describe User, type: :model do
  it 'deletes a valid user' do
    user = FactoryBot.create(:user)

    user.destroy

    expect(User.find_by_id(user.id)).to eq(nil)
    expect(User.find_by(email: user.email)).to eq(nil)
  end

  it 'fails to delete a user that is assigned to a schedule' do
    user = FactoryBot.create(:user)
    schedule = FactoryBot.create(:schedule)
    schedule.create_availabilities(user)
    user.destroy

    error_message = I18n.t("activerecord.errors.models.user.attributes.base.user_is_associated_with_schedule")
    expect(User.find_by_id(user.id)).not_to eq nil
    expect(user.errors.full_messages.to_sentence).to eq error_message
  end
end
