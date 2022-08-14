FactoryBot.define do
  factory :schedule, class: 'Schedule' do
    service_id { Service.order('random()').first.id }
    year { Faker::Number.between(from: 2000, to: 2050) }
    week { Faker::Number.between(from: 0, to: 52) }
  end
end
