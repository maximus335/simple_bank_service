# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"

  scope 'api' do
    get 'accounts', to: 'accounts#index'
    get 'accounts/open', to: 'accounts#open'
    get 'accounts/balance', to: 'accounts#balance'
    get 'accounts/balance_by_date', to: 'accounts#balance_by_date'
    get 'accounts/debit', to: 'accounts#debit'
    get 'accounts/credit', to: 'accounts#credit'
    get 'accounts/turnover', to: 'accounts#turnover'
    get 'accounts/transfer', to: 'accounts#transfer'
  end
end
