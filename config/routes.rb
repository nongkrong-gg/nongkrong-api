Rails.application.routes.draw do
  get '/up/', to: 'up#index', as: :up
  get '/up/databases', to: 'up#databases', as: :up_databases

  scope '/api' do
    devise_for :users, controllers: { registrations: 'api/users/registrations' }
  end

  namespace :api, defaults: { format: :json } do
    resources :events, only: %i[show create]
  end

  # Sidekiq ########################################################################
  #
  # require "sidekiq/web"

  # Sidekiq::Web.use ActionDispatch::Cookies
  # Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

  # authenticate :user, lambda { |u| u.admin? } do
  #   mount Sidekiq::Web => "/sidekiq"
  # end
  #
  # ###############################################################################
end
