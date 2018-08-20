# frozen_string_literal: true

module Types
  class TransactionType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :amount, Float, null: false
    field :created_at, !Types::DateTimeType, null: true
  end
end
