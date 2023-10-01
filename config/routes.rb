Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :filings, param: :id, only: [:index] do
    resources :award_lists, only: [:index]
  end
  
  resources :filers, param: :ein, only: [:index, :show] do
    resources :filings, only: [:index]
  end

  resources :recipients, only: [:index]

end
