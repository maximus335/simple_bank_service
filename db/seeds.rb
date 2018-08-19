# frozen_string_literal: true

ACCOUNT_NUMBERS = 10.times.map { '40702840' + 12.times.map{rand(10)}.join }
BALANCES = 10.times.map { rand(1000..9000) }

ACCOUNT_NUMBERS.each_with_index do |number, index|
  balance = BALANCES[index]
  account = Account.create(number: number, balance: balance)
end


