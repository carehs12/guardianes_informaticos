class Schedule
  # Manages the results of a schedule once it's optimized
  class Result < ApplicationRecord
    # Model Associations
    belongs_to :schedule, inverse_of: :results

    # Validations
    validates :day, presence: true

    enum day: %i[
      mon tue wed thu fri sat sun
    ]

    def self.format_result(result)
      formatted_result = Schedule.hours_array.map { |field_name| result[field_name] }
      formatted_result.map do |user_id|
        next unless user_id

        {
          user: User.find(user_id).full_name,
          user_id: user_id
        }
      end
    end

    def self.exclude_limits(schedule, result, day_index)
      formatted_result = format_result(result)
      start_hour = schedule.service["#{Schedule.days_array[day_index]}_hour_start"]
      end_hour = schedule.service["#{Schedule.days_array[day_index]}_hour_end"]

      [formatted_result[start_hour, end_hour - start_hour], start_hour]
    end

    def self.format(schedule)
      data = [{}, {}, {}, {}, {}, {}, {}]
      schedule.results.order(day: :asc).map.with_index do |result, day_index|
        formatted_result, start_hour = exclude_limits(schedule, result, day_index)

        data[Schedule::Result.days[result.day]] = {
          id: result.id,
          start_at: start_hour,
          schedules: formatted_result
        }
      end
    end
  end
end
