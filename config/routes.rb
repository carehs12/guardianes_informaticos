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

  authenticated :user do
    get :application, to: 'application_authenticated#show'
    root to: 'application_authenticated#show', as: 'root_authenticated'
  end

  root to: 'authentications#show'
end
