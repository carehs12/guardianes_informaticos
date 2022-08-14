FactoryBot.define do
  factory :service, class: 'Service' do
    name { Faker::Lorem.word }

    mon_hour_start { Faker::Number.between(from: 0, to: 22) }
    mon_hour_end { Faker::Number.between(from: mon_hour_start + 1, to: 23) }
    tue_hour_start { Faker::Number.between(from: 0, to: 22) }
    tue_hour_end { Faker::Number.between(from: tue_hour_start + 1, to: 23) }
    wed_hour_start { Faker::Number.between(from: 0, to: 22) }
    wed_hour_end { Faker::Number.between(from: wed_hour_start + 1, to: 23) }
    thu_hour_start { Faker::Number.between(from: 0, to: 22) }
    thu_hour_end { Faker::Number.between(from: thu_hour_start + 1, to: 23) }
    fri_hour_start { Faker::Number.between(from: 0, to: 22) }
    fri_hour_end { Faker::Number.between(from: fri_hour_start + 1, to: 23) }
    sat_hour_start { Faker::Number.between(from: 0, to: 22) }
    sat_hour_end { Faker::Number.between(from: sat_hour_start + 1, to: 23) }
    sun_hour_start { Faker::Number.between(from: 0, to: 22) }
    sun_hour_end { Faker::Number.between(from: sun_hour_start + 1, to: 23) }
  end
end
