require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it 'creates the schedule and its result records' do
    schedule = FactoryBot.create(:schedule)

    expect(schedule.id).not_to eq(nil)
    expect(schedule.results.size).to eq(7)
  end

  it 'creates 7 availabilities for a single user' do
    schedule = FactoryBot.create(:schedule)
    user = FactoryBot.create(:user)

    expect(schedule.availabilities.size).to eq(0)
    schedule.create_availabilities(user)
    expect(schedule.availabilities.size).to eq(7)
    expect(schedule.availabilities.first.user.id).to eq(user.id)
  end
end
