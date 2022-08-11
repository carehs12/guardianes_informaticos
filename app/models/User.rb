class User < ApplicationRecord
  devise(:database_authenticatable, :recoverable, authentication_keys: [:username])

  # Model Associations
  has_one :detail, inverse_of: :user, class_name: 'User::Detail', autosave: true

  # Active Storage Attachments
  has_one_attached :profile_picture

  # Nested Attributes
  accepts_nested_attributes_for :detail, update_only: true

  # Validations
  validates :username, presence: true, uniqueness: true
end
