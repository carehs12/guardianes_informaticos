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
