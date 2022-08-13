# Manages schedules in the system
class Schedule < ApplicationRecord
  # Model Associations
  has_many :availabities, inverse_of: :schedule, class_name: 'Schedule::Availability', autosave: true,
                          dependent: :destroy
  has_many :results, inverse_of: :schedule, class_name: 'Schedule::Result', autosave: true, dependent: :destroy

  # Validations
  validates :year, :week, presence: true

  # Hooks
  before_create :validate_data
  after_create :create_results

  def create_availabilities(user)
    0..7.times do |day|
      availabities.create!(day: day, user: user)
    end
  end

  def destroy_availabilities(user)
    availabilities.where(user: user).destroy_all
  end

  protected

  def validate_data
    validator = ValidatorService.new(self)
    return true if validator.validate_schedule

    errors.add(:base, :schedule_configuration_is_invalid)
    raise ActiveRecord::Rollback
  end

  def create_results
    0..7.times do |day|
      results.create!(day: day)
    end
  end
end
