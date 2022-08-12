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

  def self.index(page = 1, per_page = 25, query = nil)
    data = joins(:detail)

    unless query.blank?
      subquery1 = data.where('lower(username) like ?', "%#{query}%")
      subquery2 = data.where('lower(first_names) like ?', "%#{query}%")
      subquery3 = data.where('lower(last_names) like ?', "%#{query}%")

      data = data.where('lower(email) like ?', "%#{query}%").or(subquery1).or(subquery2).or(subquery3)
    end
    total_records = data.count
    data = select_and_paginate_fields(data, page, per_page)
    paginate_records(total_records, data)
  end

  def show
    {
      id: id,
      email: email,
      username: username,
      profile_picture_src: profile_picture_src,
      detail_attributes: detail.attributes
    }
  end

  def self.add_profile_pictures(data)
    data.map do |record|
      record_attributes = record.attributes
      record_attributes['profile_picture_src'] = record.profile_picture_src
      record_attributes
    end
  end

  def self.select_and_paginate_fields(data, page, per_page)
    data = data.select(
      'users.id',
      :username,
      :email,
      :first_names,
      :last_names,
      :address,
      :personal_phone
    )
    add_profile_pictures(paginate_data(data, page, per_page))
  end

  def profile_picture_src
    return ActionController::Base.helpers.asset_path('no-profile-picture.png') unless profile_picture.attached?

    Rails.application.routes.url_helpers.rails_blob_path(profile_picture, only_path: true)
  end
end
