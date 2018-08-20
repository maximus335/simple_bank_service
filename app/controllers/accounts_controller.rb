# frozen_string_literal: true

class AccountsController < ApplicationController

  # GET /api/index
  # Возвращает все счета
  def index
    content = Account.all
    render json: content, status: 200
  end

  # GET /api/open
  # Создает новый счет
  def open
    content = Account.open
    render json: content, status: 200
  end

  # GET /api/balance
  # Возвращает баланс счета на текущюю дату
  # @params [String] number
  #  номер счета
  def balance
    content = AccountService.balance(number)
    render json: content, status: 200
  end

  # GET /api/balance_by_date
  # Возвращает баланс счета на произвольную дату
  # @params [String] number
  #  номер счета
  # @params [String] date
  #  дата
  def balance_by_date
    content = AccountService.balance_by_date(number, date)
    render json: content, status: 200
  end

  # GET /api/debit
  # Зачисляет средства на счет
  # @params [String] number
  #  номер счета
  # @params [Float] amount
  #  колличество
  def debit
    content = AccountService.debit(number, amount)
    render json: content, status: 200
  end

  # GET /api/credit
  # Списывает средства со счета
  # @params [String] number
  #  номер счета
  # @params [Float] amount
  #  колличество
  def credit
    content = AccountService.credit(number, amount)
    render json: content, status: 200
  end

  # GET /api/transfer
  # @params [String] from
  #  номер счета для списания
  # @params [String] to
  #  номер счета для зачисления
  # @params [Float] amount
  #  колличество
  def transfer
    content = AccountService.transfer(from, to, amount)
    render json: content, status: 200
  end

  # GET /api/turnover
  # Возвращает оборот по счету за произвольный период
  # @params [String] number
  #  номер счета
  # @params [String] date_start
  #  дата начала
  # @params [String] date_finish
  #  дата конца
  def turnover
    content = AccountService.turnover(number, date_start, date_finish)
    render json: content, status: 200
  end

  private

  def number
    params[:number]
  end

  def date
    params[:date]
  end

  def date_start
    params[:date_start]
  end

  def date_finish
    params[:date_finish]
  end

  def amount
    params[:amount].to_f
  end

  def from
    params[:from]
  end

  def to
    params[:to]
  end
end
