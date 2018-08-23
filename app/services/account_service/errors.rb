# frozen_string_literal: true

class AccountService
  # Модуль пространств имён классов ошибок, специфичных для приложения
  module Errors
    # Класс ошибок сигнализирующий о том, что запись счета не найдена
    class NotFound < RuntimeError
      def initialize(number)
        super("Account No. #{number} not found")
      end
    end

    # Класс ошибок сигнализирующий о том, что счет заблокирован
    class Blocked < RuntimeError
      def initialize(number)
        super("Account No. #{number} blocked")
      end
    end

    # Класс ошибок сигнализирующий о том, что на счете недостаточно средств
    # для совершения операции
    class InsufficientFunds < RuntimeError
      def initialize
        super('Insufficient funds on account')
      end
    end
  end
end
