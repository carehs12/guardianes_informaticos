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
    get :application, to: 'application#show'
    root to: 'application#show', as: 'root_authenticated'
  end

  root to: 'authentications#index'
end
