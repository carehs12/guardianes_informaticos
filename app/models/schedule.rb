# Manages schedules in the system
class Schedule < ApplicationRecord
  # Model Associations
  has_many :availabilities, inverse_of: :schedule, class_name: 'Schedule::Availability', autosave: true,
                            dependent: :destroy
  has_many :results, inverse_of: :schedule, class_name: 'Schedule::Result', autosave: true, dependent: :destroy
  belongs_to :service, inverse_of: :schedules, class_name: 'Service'

  # Nested attributes
  accepts_nested_attributes_for :availabilities

  # Validations
  validates :year, :week, presence: true

  # Hooks
  after_create :create_results

  def create_availabilities(user)
    0..7.times do |day|
      availabilities.create!(day: day, user: user)
    end
  end

  def destroy_availabilities(user)
    availabilities.where(user: user).destroy_all
  end

  def show
    work_hours = assigned_hours.map do |assigned_hour|
      { user: User.find(assigned_hour['user_id']).full_name, work_hours: assigned_hour['work_hours'] }
    end

    attributes.merge({ results: Schedule::Result.format(self), work_hours: work_hours, service_name: service.name })
  end

  def optimize
    return if availabilities.size.zero?

    perform_optimization
  end

  def perform_optimization
    user_keys, algorithm_data = generate_algorithm_data
    hours_array = self.class.hours_array
    result, _cost, work_hours = create_and_execute_optimizer(algorithm_data)
    update_assigned_hours(user_keys, work_hours)

    result.each_with_index do |day_data, day_index|
      day_data.each_with_index do |user_index, hour_index|
        next unless user_index

        results.find_by(day: day_index).update(hours_array[hour_index] => user_keys[user_index])
      end
    end
  end

  def create_and_execute_optimizer(algorithm_data)
    optimizer = OptimizerService.new(algorithm_data)
    optimizer.optimize_shifts
  end

  def update_assigned_hours(user_keys, work_hours)
    work_hours = work_hours.keys.map do |user_index|
      { user_id: user_keys[user_index], work_hours: work_hours[user_index] }
    end

    update!(assigned_hours: work_hours)
  end

  def generate_algorithm_data
    users_list_ = users_list
    algorithm_data = []

    users_list_.each_with_index do |user_id, index|
      availabilities_array = calculate_availabilities_array(user_id, index)
      availabilities_array = availabilities_array.map.with_index do |arr, day_index|
        exclude_limits(arr, day_index, replace: true)
      end

      algorithm_data.push(availabilities_array)
    end

    [users_list_, algorithm_data]
  end

  def exclude_limits(daily_array, day_index, replace: false)
    start_hour = service["#{Schedule.days_array[day_index]}_hour_start"] || 24
    end_hour = service["#{Schedule.days_array[day_index]}_hour_end"] || 0
    if replace
      daily_array[0, start_hour] = Array.new(start_hour, nil)
      daily_array[end_hour, 24] = Array.new(24 - end_hour, nil)
      daily_array
    else
      daily_array[start_hour, end_hour - start_hour]
    end
  end

  def self.hours_array
    %i[
      hour00 hour01 hour02 hour03 hour04 hour05 hour06 hour07
      hour08 hour09 hour10 hour11 hour12 hour13 hour14 hour15
      hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23
    ]
  end

  def self.days_array
    %i[mon tue wed thu fri sat sun]
  end

  protected

  def users_list
    availabilities.select('distinct(user_id) as id').map(&:id).sort
  end

  def calculate_availabilities_array(user_id, index)
    availabilities.where(user_id: user_id).order(:day).map do |availability|
      self.class.hours_array.map { |key| availability[key] ? index : nil }
    end
  end

  def create_results
    0..7.times do |day|
      results.create!(day: day)
    end
  end
end
