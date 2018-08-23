# frozen_string_literal: true

# Сервис предоставляющий методы для работы с записями счетов
class AccountService
  # Создает объект класса и переводит средства с счета на счет, возвращает
  # записи счетов после обновления
  # @params [String] from
  #  номер счета для списания
  # @params [String] to
  #  номер счета для зачисление
  # @params [Float] amount
  #  количество средств для транзакции
  # @return [Array<Account>]
  #  обновленые записи счетов
  def self.transfer(from, to, amount)
    new.transfer(from, to, amount)
  end

  # Создает объект класса и списывает средства со счета, возвращает
  # запись счета после обновления
  # @params [String] number
  #  номер счета для списания
  # @params [Float] amount
  #  количество средств для транзакции
  # @return [Account]
  #  обновленая запись счета
  def self.credit(number, amount)
    new.credit(number, amount)
  end

  # Создает объект класса и зачисляет средства на счет, возвращает
  # запись счета после обновления
  # @params [String] number
  #  номер счета для зачисления
  # @params [Float] amount
  #  количество средств для транзакции
  # @return [Account]
  #  обновленая запись счета
  def self.debit(number, amount)
    new.debit(number, amount)
  end

  # Создает объект класса и возвращает баланс счета на текущую дату
  # @params [String] number
  #  номер счета
  # @return [Float]
  #  баланс счета на текущую дату
  def self.balance(number)
    new.balance(number)
  end

  # Создает объект класса и возвращает баланс счета на произвольную дату
  # @params [String] number
  #  номер счета
  # @params [String] date
  #  строка с датой
  # @return [Float]
  #  баланс счета на произвольную дату
  def self.balance_by_date(number, date)
    new.balance_by_date(number, date)
  end

  # Создает объект класса и возвращает оборот по счету за произвольный период
  # @params [String] number
  #  номер счета
  # @params [String] date_start
  #  строка с датой начала периода
  # @params [String] date_finish
  #  строка с датой конца периода
  # @return [Hash]
  #  ассоциативный массив с данными
  def self.turnover(number, date_start, date_finish)
    new.turnover(number, date_start, date_finish)
  end

  def transfer(from, to, amount)
    account_from = account(from)
    account_to = account(to)
    Account.transaction do
      account_from.lock!
      account_to.lock!
      check_balance!(amount, account_from.balance)
      account_from.balance -= amount
      account_from.save!
      account_to.balance += amount
      account_to.save!
      Transaction.create(account_id: account_from.id,
                         to: to,
                         amount: amount,
                         type_operation: 'credit')
      Transaction.create(account_id: account_to.id,
                         from: from,
                         amount: amount,
                         type_operation: 'debit')
    end
    transfer_result(account_from, account_to)
  end

  def debit(number, amount)
    account = account(number)
    account.with_lock do
      account.balance += amount
      account.save!
      Transaction.create(account_id: account.id,
                         amount: amount,
                         type_operation: 'debit')
    end
    account.reload
  end

  def credit(number, amount)
    account = account(number)
    account.with_lock do
      balance = account.balance
      check_balance!(amount, balance)
      account.balance -= amount
      account.save!
      Transaction.create(account_id: account.id,
                         amount: amount,
                         type_operation: 'credit')
    end
    account.reload
  end

  def balance(number)
    account = account(number)
    account.balance
  end

  def balance_by_date(number, date)
    account_id = account(number).id
    date = Time.parse(date).tomorrow.strftime('%Y-%m-%d')
    total_turnover = Transaction
                     .where('created_at < ? AND account_id = ?',
                            date,
                            account_id)
                     .group(:type_operation)
                     .sum(:amount)
    debit = total_turnover['debit'] || 0.0
    credit = total_turnover['credit'] || 0.0
    debit - credit
  end

  def turnover(number, date_start, date_finish)
    account_id = account(number).id
    start = Time.parse(date_start).strftime('%Y-%m-%d')
    finish = Time.parse(date_finish).tomorrow.strftime('%Y-%m-%d')
    result = Transaction
             .where('created_at >= ? AND created_at < ? AND account_id = ?',
                    start,
                    finish,
                    account_id)
             .group_by(&:type_operation)
    result.each_with_object({}) do |(k, v), memo|
      memo[k] = v.map(&:attributes)
    end
  end

  private

  # Подготавливает данные для метода transfer
  # @param [Account] account_from
  #  запись счета списания
  # @param [Account] account_to
  #  запись счета зачисления
  # @return [Hash]
  #  результат
  def transfer_result(account_from, account_to)
    {
      from: account_from.reload,
      to: account_to.reload
    }
  end

  # Возвращает запись счета по номеру
  # @params [String] number
  #  номер счета
  # @return [Account]
  #  запись счета
  def account(number)
    account = Account.find_by(number: number)
    check_account!(account, number)
    check_bloked!(account.blocked, number)
    account
  end

  # Проверяет найдена ли запись счета
  # @params [Account] account
  #  запись счета
  # @params [String] number
  #  номер счета
  # @raise [RuntimeError]
  #  если запись не найдена
  def check_account!(account, number)
    return if account
    raise "Account No. #{number} not found"
  end

  # Проверяет заблокирован или нет счет
  # @params [Boolean] blocked
  #  значение подя blocked записи счета
  # @params [String] number
  #  номер счета
  # @raise [RuntimeError]
  #  если счет заблокирован
  def check_bloked!(blocked, number)
    return unless blocked
    raise "Account No. #{number} blocked"
  end

  # Проверяет достаточно ли средств на счете для совершения операции
  # @params [Float] amount
  #  количесвтво для совершения операции
  # @params [Float] balance
  #  текущий баланс счета
  # @raise [RuntimeError]
  #  если средств на счете не достаточно
  def check_balance!(amount, balance)
    return if balance >= amount
    raise 'Insufficient funds on account'
  end
end
