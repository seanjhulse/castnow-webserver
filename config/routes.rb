Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'magic#movies'
  post '/play/:id' => 'magic#play', as: 'play'
  get '/pause/' => 'magic#play_pause', as: 'play_pause'
  get '/stop' => 'magic#stop', as: 'stop'
  get '/seek/:direction' => 'magic#seek', as: 'seek'
  get '/sound/' => 'magic#sound_toggle', as: 'sound_toggle'
  get '/show/:show/episodes/' => 'magic#episodes', as: 'episodes'

  resources :users
  post 'users/:id/login' => 'users#login', as: 'users_login'
  post '/logout' => 'users#logout', as: 'users_logout'

  get '/settings' => 'settings#edit', as: 'settings'
  put '/settings' => 'settings#update', as: 'settings_update'
end
