Rails.application.routes.draw do
  get 'filings/index'
  get 'filings/show'
  get 'filings/upload'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
