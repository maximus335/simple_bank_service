# frozen_string_literal: true

module Types
  class TransferType < GraphQL::Schema::Object
    field :from, AccountType, null: false
    field :to, AccountType, null: false
  end
end
