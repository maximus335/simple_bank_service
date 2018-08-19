FactoryBot.define do
  factory :transaction, class: 'Transaction' do
    amount { 1000.0 }
    type_operation { 'credit' }

    association :account, factory: :account
  end
end
