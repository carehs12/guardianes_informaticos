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
  end
end
