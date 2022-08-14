require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it 'creates the algorithm data with the correct format' do
    schedule = FactoryBot.create(:schedule)
    users = [FactoryBot.create(:user), FactoryBot.create(:user), FactoryBot.create(:user)]

    users.map { |user| schedule.create_availabilities(user) }

    users.map do |user|
      (0..6).each do |day|
        availability_attributes = FactoryBot.attributes_for(:schedule_availability)
        schedule.availabilities.where(user: user, day: day).update!(availability_attributes)
      end
    end

    _users_keys, algorithm_data = schedule.generate_algorithm_data

    hours_array = %i[
      hour00 hour01 hour02 hour03 hour04 hour05 hour06 hour07
      hour08 hour09 hour10 hour11 hour12 hour13 hour14 hour15
      hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23
    ]

    users.each_with_index do |user, user_index|
      (0..6).each do |day|
        availability = schedule.availabilities.find_by(user: user, day: day)
        (0..23).each do |hour|
          next if schedule.service["#{Schedule.days_array[day]}_hour_start"].nil?
          next if schedule.service["#{Schedule.days_array[day]}_hour_start"] > hour
          next if schedule.service["#{Schedule.days_array[day]}_hour_end"] <= hour

          if availability[hours_array[hour]]
            expect(algorithm_data[user_index][day][hour]).to eq(user_index)
          else
            expect(algorithm_data[user_index][day][hour]).to be_nil
          end
        end
      end
    end
  end

  it 'fills the schedule with the best information' do
    schedule = FactoryBot.create(:schedule)
    users = [FactoryBot.create(:user), FactoryBot.create(:user), FactoryBot.create(:user)]
    users_ids = users.map(&:id)
    users_ids.push(nil)

    users.map { |user| schedule.create_availabilities(user) }

    users.map do |user|
      (0..6).each do |day|
        availability_attributes = FactoryBot.attributes_for(:schedule_availability)
        schedule.availabilities.where(user: user, day: day).update!(availability_attributes)
      end
    end

    schedule.optimize

    hours_array = %i[
      hour00 hour01 hour02 hour03 hour04 hour05 hour06 hour07
      hour08 hour09 hour10 hour11 hour12 hour13 hour14 hour15
      hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23
    ]

    (0..6).each do |day|
      daily_result = schedule.results.find_by(day: day)
      (0..23).each do |hour|
        expect(users_ids.include?(daily_result[hours_array[hour]])).to be true
      end
    end
  end
end
