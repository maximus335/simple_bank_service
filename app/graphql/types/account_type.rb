# frozen_string_literal: true

module Types
  class AccountType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :number, String, null: false
    field :balance, Float, null: false
    field :created_at, !Types::DateTimeType, null: true
    field :blocked, Boolean, null: false
  end
end
