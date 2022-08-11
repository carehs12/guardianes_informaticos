Rails.application.routes.draw do
  devise_for(
    :users,
    controllers: {
      passwords: 'users/passwords',
      sessions: 'users/sessions'
    },
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'password'
    }
  )
end
