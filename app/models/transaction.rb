# frozen_string_literal: true

class Transaction < ApplicationRecord
  validates :type_operation, inclusion: %w[credit debit]
  validates :from, length: { is: 20 },
                   uniqueness: true,
                   allow_nil: true

  validates_format_of :from,
                      with: /\A[0-9]*\Z/,
                      message: 'the from must consist of 20 digits',
                      allow_nil: true

  validates :to, length: { is: 20 },
                 uniqueness: true,
                 allow_nil: true

  validates_format_of :to,
                      with: /\A[0-9]*\Z/,
                      message: 'the to must consist of 20 digits',
                      allow_nil: true

  belongs_to :account
end
