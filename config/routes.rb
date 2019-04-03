Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'magic#movies'
  post '/cast/:title' => 'magic#cast', as: 'cast'
  get '/play/' => 'magic#play', as: 'play'
  get '/pause/' => 'magic#pause', as: 'pause'
  get '/stop' => 'magic#stop', as: 'stop'
  get '/seek/:direction' => 'magic#seek', as: 'seek'
  get '/sound_on/' => 'magic#sound_on', as: 'sound_on'
  get '/sound_off/' => 'magic#sound_off', as: 'sound_off'
  get '/sound_down/' => 'magic#sound_down', as: 'sound_down'
  get '/sound_up/' => 'magic#sound_up', as: 'sound_up'
  get '/time/' => 'magic#time', as: 'time'
  get '/show/:show/episodes/' => 'magic#episodes', as: 'episodes'

  resources :users
  post 'users/:id/login' => 'users#login', as: 'users_login'
  post '/logout' => 'users#logout', as: 'users_logout'

  get '/settings' => 'settings#edit', as: 'settings'
  put '/settings' => 'settings#update', as: 'settings_update'

end
