User.create!(
  username: 'chermosilla',
  email: 'efrainh12@galileo.edu',
  password: 'recorrido123',
  password_confirmation: 'recorrido123',
  detail_attributes: {
    first_names: 'Carlos Efraín',
    last_names: 'Hermosilla Samayoa'
  }
)

Service.create!(
  name: 'Servicio de Ejemplo',
  mon_hour_start: 8,
  mon_hour_end: 16,
  tue_hour_start: 8,
  tue_hour_end: 16,
  wed_hour_start: 8,
  wed_hour_end: 16,
  thu_hour_start: 8,
  thu_hour_end: 16,
  fri_hour_start: 8,
  fri_hour_end: 16,
  sat_hour_start: 10,
  sat_hour_end: 20,
  sun_hour_start: 10,
  sun_hour_end: 20
)

3.times { FactoryBot.create(:user) }
3.times do
  schedule = FactoryBot.create(:schedule)
  users = User.order('random()').limit(3)
  users.each { |user| schedule.create_availabilities(user) }

  users.map do |user|
    (0..6).each do |day|
      availability_attributes = FactoryBot.attributes_for(:schedule_availability)
      schedule.availabilities.where(user: user, day: day).update!(availability_attributes)
    end
  end
  schedule.optimize
end
