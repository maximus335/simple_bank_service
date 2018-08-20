# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject

    field :accounts, [AccountType], null: false do
      description 'Return all accounts'
    end

    field :balance, Float, null: false do
      argument :number, String, required: true
    end

    field :balance_by_date, Float, null: false do
      argument :number, String, required: true
      argument :date, String, required: true
    end

    field :turnover, TurnoverType, null: false do
      argument :number, String, required: true
      argument :start, String, required: true
      argument :finish, String, required: true
    end

    def accounts
      Account.all
    end

    def balance(number:)
      AccountService.balance(number)
    end

    def balance_by_date(number:, date:)
      AccountService.balance_by_date(number, date)
    end

    def turnover(number:, start:, finish:)
      AccountService.turnover(number, start, finish)
    end
  end
end
