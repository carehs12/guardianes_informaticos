class Schedule
  class Result < ApplicationRecord
    # Model Associations
    belongs_to :schedule, inverse_of: :results

    # Validations
    validates :day, presence: true

    enum day: %i[
      mon tue wed thu fri sat sun
    ]
  end
end
