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

    def self.format(schedule)
      data = [{}, {}, {}, {}, {}, {}, {}]
      schedule.results.order(day: :asc).map do |result|
        formatted_result = format_result(result)

        data[Schedule::Result.days[result.day]] = {
          id: result.id,
          start_at: 0, # TODO: FIX THIS
          schedules: formatted_result
        }
      end
    end
  end
end
