# Manages services in the system
class Service < ApplicationRecord
  # Model Associations
  has_many :schedules, inverse_of: :service, class_name: 'Schedule'
  # Validations
  validates :name, presence: true, uniqueness: true

  def self.index(page = 1, per_page = 25, query = nil)
    data = self

    data = data.where('lower(name) like ?', "%#{query}%") unless query.blank?
    total_records = data.count
    data = select_and_paginate_fields(data, page, per_page)
    pagination_format(total_records, data)
  end

  def show
    {
      id: id,
      name: name
    }
  end

  def self.select_and_paginate_fields(data, page, per_page)
    data = data.select(
      :id,
      :name
    )
    paginate_data(data, page, per_page)
  end

  def destroy
    if Schedule::Availability.where(service: self).count.positive?
      errors.add(:base, :service_is_associated_with_schedule)
      return
    end

    super
  end
end
