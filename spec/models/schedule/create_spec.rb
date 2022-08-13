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

  it 'fails to create a schedule if the limits on a day are invalid' do
    schedule_attributes = FactoryBot.attributes_for(:schedule)
    schedule_attributes[:mon_hour_start] = nil
    schedule = Schedule.create(schedule_attributes)

    error_message = I18n.t('activerecord.errors.models.schedule.attributes.base.schedule_configuration_is_invalid')
    expect(schedule.id).to eq(nil)
    expect(schedule.errors.full_messages.to_sentence).to eq(error_message)
  end

  it 'fails to create a schedule if a day is out of bounds' do
    schedule_attributes = FactoryBot.attributes_for(:schedule)
    schedule_attributes[:tue_hour_start] = 40
    schedule = Schedule.create(schedule_attributes)

    error_message = I18n.t('activerecord.errors.models.schedule.attributes.base.schedule_configuration_is_invalid')
    expect(schedule.id).to eq(nil)
    expect(schedule.errors.full_messages.to_sentence).to eq(error_message)
  end

  it 'fails to create a schedule if a day is inconsistent' do
    schedule_attributes = FactoryBot.attributes_for(:schedule)
    aux = schedule_attributes[:wed_hour_start]
    schedule_attributes[:wed_hour_start] = schedule_attributes[:wed_hour_end]
    schedule_attributes[:wed_hour_end] = aux
    schedule = Schedule.create(schedule_attributes)

    error_message = I18n.t('activerecord.errors.models.schedule.attributes.base.schedule_configuration_is_invalid')
    expect(schedule.id).to eq(nil)
    expect(schedule.errors.full_messages.to_sentence).to eq(error_message)
  end
end
