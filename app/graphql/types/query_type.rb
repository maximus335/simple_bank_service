# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject

    field :accounts, [AccountType], null: false do
      description 'Return all accounts'
    end

    def accounts
      Account.all
    end

    field :balance, Float, null: false do
      argument :number, String, required: true
    end

    def balance(number:)
      AccountService.balance(number)
    end

    field :balance_by_date, Float, null: false do
      argument :number, String, required: true
      argument :date, String, required: true
    end

    def balance_by_date(number:, date:)
      AccountService.balance_by_date(number, date)
    end

    field :turnover, String, null: false do
      argument :number, String, required: true
      argument :datestart, String, required: true
      argument :datefinish, String, required: true
    end

    def turnover(number:, datestart:, datefinish:)
      AccountService.turnover(number, datestart, datefinish)
    end
  end
end
