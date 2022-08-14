class Schedule
  class Availability < ApplicationRecord
    # Model Associations
    belongs_to :schedule, inverse_of: :availabilities
    belongs_to :user

    # Validations
    validates :day, presence: true

    enum day: %i[
      mon tue wed thu fri sat sun
    ]

    def self.index(schedule)
      {
        id: schedule.id,
        year: schedule.year,
        week: schedule.week,
        # We center the date in the middle of the week and save time zone issues
        date: Date.commercial(schedule.year, schedule.week, 4), 
        service_name: schedule.service.name,
        availabilities: format_availabilities(schedule)
      }
    end

    def self.format_availabilities(schedule)
      [*0..6].map do |day_index|
        schedule.availabilities.where(day: day_index).order(user_id: :asc).map do |availability|

          { id: availability.id, user_id: availability.user_id, user_name: availability.user.full_name,
            start_at: schedule.service["#{Schedule.days_array[day_index]}_hour_start"] || 24,
            availability: format_availability(schedule, availability, day_index)
          }
        end
      end
    end

    def self.format_availability(schedule, availability, day_index)
      formatted_availability = Schedule.hours_array.map do |hour|
        availability[hour]
      end

      schedule.exclude_limits(formatted_availability, day_index, replace: false)
    end
  end
end
