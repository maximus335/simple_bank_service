# frozen_string_literal: true

require 'securerandom'

class Account < ApplicationRecord
  validates :number, length: { is: 20 },
                     uniqueness: true
  validates_format_of :number,
                      with: /\A[0-9]*\Z/,
                      message: 'the account number must consist of 20 digits'

  has_many :transactions, dependent: :destroy

  def self.open
    account = new
    account.number = generate_number
    account.save
    account
  end

  def self.generate_number
    '40702840' + SecureRandom.random_number(1000000000000000000).to_s
  end.to_s
end
