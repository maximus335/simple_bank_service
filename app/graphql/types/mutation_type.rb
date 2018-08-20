module Types
  class MutationType < Types::BaseObject

    field :open, AccountType, null: false,
      description: "Create new account"

    field :debit, AccountType, null: false do
      argument :number, String, required: true
      argument :amount, Float, required: true
    end

    field :credit, AccountType, null: false do
      argument :number, String, required: true
      argument :amount, Float, required: true
    end

    field :transfer, TransferType, null: true do
      argument :from, String, required: true
      argument :to, String, required: true
      argument :amount, Float, required: true
    end

    def transfer(from:, to:, amount:)
      AccountService.transfer(from, to, amount)
    end

    def credit(number:, amount:)
      AccountService.credit(number, amount)
    end

    def debit(number:, amount:)
      AccountService.debit(number, amount)
    end

    def open
      Account.open
    end
  end
end
