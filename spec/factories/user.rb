FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Devise.friendly_token }

    detail_attributes do
      {
        first_names: Faker::Name.name,
        last_names: Faker::Name.last_name,
        birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
        address: Faker::Address.full_address,
        personal_phone: Faker::PhoneNumber.cell_phone,
        emergency_phone: Faker::PhoneNumber.cell_phone
      }
    end
  end
end
