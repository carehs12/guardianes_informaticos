FactoryBot.define do
  factory :schedule_availability, class: 'Schedule::Availability' do
    hour00 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour01 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour02 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour03 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour04 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour05 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour06 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour07 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour08 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour09 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour10 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour11 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour12 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour13 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour14 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour15 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour16 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour17 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour18 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour19 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour20 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour21 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour22 { Faker::Boolean.boolean(true_ratio: 0.65) }
    hour23 { Faker::Boolean.boolean(true_ratio: 0.65) }
  end
end
