Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'magic#movies'
  post '/play/:id' => 'magic#play', as: 'play'
  get '/pause/' => 'magic#play_pause', as: 'play_pause'
  get '/stop' => 'magic#stop', as: 'stop'
  get '/seek/:direction' => 'magic#seek', as: 'seek'
  get '/sound/' => 'magic#sound_toggle', as: 'sound_toggle'
end
