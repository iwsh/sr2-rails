Rails.application.routes.draw do
  get 'login' => 'sessions#login'

  get 'schedules/:year/:month' => 'schedules#getSchedules'
  post 'schedules' => 'schedules#postSchedules'
  put 'schedules/:id' => 'schedules#putSchedules'
  delete 'schedules/:id' => 'schedules#deleteSchedules'

  get 'users' => 'users#index'
  post 'users' => 'users#create'
  put 'users/:id' => 'users#update'
  delete 'users/:id' => 'users#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
