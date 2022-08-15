password = Devise.friendly_token
User.create!(
  username: 'chermosilla',
  email: 'efrainh12@galileo.edu',
  password: password,
  password_confirmation: password,
  detail_attributes: {
    first_names: 'Carlos Efraín',
    last_names: 'Hermosilla Samayoa'
  }
)
