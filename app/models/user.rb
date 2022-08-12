# Manages users in the system
class User < ApplicationRecord
  devise(:database_authenticatable, :validatable, :recoverable, authentication_keys: [:username])

  # Model Associations
  has_one :detail, inverse_of: :user, class_name: 'User::Detail', autosave: true, dependent: :destroy

  # Active Storage Attachments
  has_one_attached :profile_picture

  # Nested Attributes
  accepts_nested_attributes_for :detail, update_only: true

  # Validations
  validates :username, presence: true, uniqueness: true

  def self.index(query = nil, page = 0, per_page = 25)
    data = joins(:detail)

    unless query.blank?
      subquery1 = data.where('username like ?', "%#{query}%")
      subquery2 = data.where('first_names like ?', "%#{query}%")
      subquery3 = data.where('last_names like ?', "%#{query}%")

      data = data.where('email like ?', "%#{query}%").or(subquery1).or(subquery2).or(subquery3)
    end
    total_records = data.count
    paginate_records(total_records, data.limit(per_page).offset(page))
  end

  def show
    {
      email: email,
      username: username,
      profile_picture_src: profile_picture_src,
      detail_attributes: detail.attributes
    }
  end

  protected

  def profile_picture_src
    return ActionController::Base.helpers.asset_path('no-profile-picture.png') unless profile_picture.attached?

    Rails.application.routes.url_helpers.rails_blob_path(profile_picture, only_path: true)
  end
end
