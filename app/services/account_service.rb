# frozen_string_literal: true

class AccountService

  def self.transfer(from, to, amount)
    new.transfer(from, to, amount)
  end

  def self.credit(number, amount)
    new.credit(number, amount)
  end

  def self.debit(number, amount)
    new.debit(number, amount)
  end

  def self.balance(number)
    new.balance(number)
  end

  def self.turnover(number, date_start, date_finish)
    new.turnover(number, date_start, date_finish)
  end

  def transfer(from, to, amount)
    account_from = account(from)
    account_to = account(to)
    check_balance!(amount, account_from.balance)
    Account.transaction do
      account_from.update!(balance: account_from.balance - amount)
      account_to.update!(balance: account_to.balance + amount)
      Transaction.transaction do
        Transaction
        .create(account_id: account_from.id, to: to, amount: amount, type_operation: 'credit')
        Transaction
        .create(account_id: account_to.id, from: from, amount: amount, type_operation: 'debit')
      end
    end
  end

  def debit(number, amount)
    account = account(number)
    balance = account.balance
    Account.transaction do
      account.update!(balance: balance + amount)
      Transaction.transaction do
        Transaction
        .create(account_id: account.id, amount: amount, type_operation: 'debit')
      end
    end
  end

  def credit(number, amount)
    account = account(number)
    balance = account.balance
    check_balance!(amount, balance)
    Account.transaction do
      account.update!(balance: balance - amount)
      Transaction.transaction do
        Transaction
        .create(account_id: account.id, amount: amount, type_operation: 'credit')
      end
    end
  end

  def balance(number)
    account = account(number)
    account.balance
  end

  def balance_by_date(number, date)
    account_id = account(number).id
    date = Time.parse(date)
    Transaction
      .where("created_at <= ? AND account_id = ?)", date, account_id )
      .group_by(&:type_operation)
      .sum(:amount)
  end

  def turnover(number, date_start, date_finish)
    account_id = account(number).id
    start = Time.parse(date_start)
    finish = Time.parse(date_finish)
    result = Transaction
      .where("created_at >= ? AND created_at <= ? AND account_id = ?)", start, finish, account_id )
      .group_by(&:type_operation)
    result.each_with_object({}) do |(k,v), memo|
      memo[k] = v.map(&:attributes)
    end
  end

  private

  def account(number)
    account = Account.find_by(number: number)
    check_account!(account, number)
    check_bloked!(account.blocked, number)
    account
  end

  def check_account!(account, number)
    return if account
    raise "Account No. #{number} not found"
  end

  def check_bloked!(blocked, number)
    return unless blocked
    raise "Account No. #{number} blocked"
  end

  def check_balance!(amount, balance)
    return if balance >= amount
    raise 'Insufficient funds on account'
  end
end
