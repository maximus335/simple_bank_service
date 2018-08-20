# frozen_string_literal: true

module Types
  class TurnoverType < GraphQL::Schema::Object
    field :debit, [TransactionType], null: true
    field :credit, [TransactionType], null: true
  end
end
