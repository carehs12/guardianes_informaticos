# Manages schedules in the system

class Schedule < ApplicationRecord
  # Model Associations
  has_many :availabities, inverse_of: :schedule, class_name: 'Schedule::Availability', autosave: true,
                          dependent: :destroy
  has_many :results, inverse_of: :result, class_name: 'Schedule::Result', autosave: true, dependent: :destroy

  # Validations
  validates :year, :week, presence: true
end
