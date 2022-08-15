FactoryBot.define do
  factory :schedule_availability, class: 'Schedule::Availability' do
    hour00 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour01 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour02 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour03 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour04 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour05 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour06 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour07 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour08 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour09 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour10 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour11 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour12 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour13 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour14 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour15 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour16 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour17 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour18 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour19 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour20 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour21 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour22 { Faker::Boolean.boolean(true_ratio: 0.70) }
    hour23 { Faker::Boolean.boolean(true_ratio: 0.70) }
  end
end
