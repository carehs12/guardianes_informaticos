# Manages schedules in the system
class Schedule < ApplicationRecord
  # Model Associations
  has_many :availabilities, inverse_of: :schedule, class_name: 'Schedule::Availability', autosave: true,
                            dependent: :destroy
  has_many :results, inverse_of: :schedule, class_name: 'Schedule::Result', autosave: true, dependent: :destroy
  belongs_to :service, inverse_of: :schedules, class_name: 'Service'

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

  def optimize
    user_keys, algorithm_data = generate_algorithm_data
    hours_array = self.class.hours_array
    optimizer = OptimizerService.new(algorithm_data)
    result, _cost, _work_hours = optimizer.optimize_shifts

    result.each_with_index do |day_data, day_index|
      day_data.each_with_index do |user_index, hour_index|
        next unless user_index

        results.find_by(day: day_index).update(hours_array[hour_index] => user_keys[user_index])
      end
    end
  end

  def generate_algorithm_data
    users_list_ = users_list
    algorithm_data = []

    users_list_.each_with_index do |user_id, index|
      availabilities_array = calculate_availabilities_array(user_id, index)
      algorithm_data.push(availabilities_array)
    end

    [users_list_, algorithm_data]
  end

  def self.hours_array
    %i[
      hour00 hour01 hour02 hour03 hour04 hour05 hour06 hour07
      hour08 hour09 hour10 hour11 hour12 hour13 hour14 hour15
      hour16 hour17 hour18 hour19 hour20 hour21 hour22 hour23
    ]
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
