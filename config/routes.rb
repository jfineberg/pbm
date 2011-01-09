Pbm::Application.routes.draw do
  get 'pages/home'
  get 'pages/contact'

  get 'locations/add_machine'
  get 'locations/remove_machine'
  get 'locations/update_machine_condition'
  get 'locations/add_high_score'

  resources :locations, :machines do
    get :autocomplete, :on => :collection
  end

  devise_for :users
  root :to => 'pages#home'
end
