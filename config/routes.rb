Rails.application.routes.draw do
  get 'login' => 'sessions#login'

  get 'schedules/:year/:month' => 'schedules#getSchedules'
  post 'schedules' => 'schedules#postSchedules'
  put 'schedules/:id' => 'schedules#putSchedules'
  delete 'schedules/:id' => 'schedules#deleteSchedules'

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
