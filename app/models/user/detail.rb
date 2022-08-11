class User
  class Detail < ApplicationRecord
    belongs_to :user, inverse_of: :detail
  end
end
