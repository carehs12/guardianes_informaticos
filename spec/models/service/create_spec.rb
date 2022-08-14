require 'rails_helper'

RSpec.describe Service, type: :model do
  it 'creates a valid service with valid data' do
    service = FactoryBot.create(:service)

    expect(service.id).not_to eq(nil)
  end

  it 'fails to create a service if the limits on a day are invalid' do
    service_attributes = FactoryBot.attributes_for(:service)
    service_attributes[:mon_hour_start] = nil
    service = Service.create(service_attributes)

    error_message = I18n.t('activerecord.errors.models.service.attributes.base.service_configuration_is_invalid')
    expect(service.id).to eq(nil)
    expect(service.errors.full_messages.to_sentence).to eq(error_message)
  end

  it 'fails to create a service if a day is out of bounds' do
    service_attributes = FactoryBot.attributes_for(:service)
    service_attributes[:tue_hour_start] = 40
    service = Service.create(service_attributes)

    error_message = I18n.t('activerecord.errors.models.service.attributes.base.service_configuration_is_invalid')
    expect(service.id).to eq(nil)
    expect(service.errors.full_messages.to_sentence).to eq(error_message)
  end

  it 'fails to create a service if a day is inconsistent' do
    service_attributes = FactoryBot.attributes_for(:service)
    aux = service_attributes[:wed_hour_start]
    service_attributes[:wed_hour_start] = service_attributes[:wed_hour_end]
    service_attributes[:wed_hour_end] = aux
    service = Service.create(service_attributes)

    error_message = I18n.t('activerecord.errors.models.service.attributes.base.service_configuration_is_invalid')
    expect(service.id).to eq(nil)
    expect(service.errors.full_messages.to_sentence).to eq(error_message)
  end
end
