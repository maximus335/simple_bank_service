FactoryBot.define do
  factory :account, class: 'Account' do
    number { rand(10000000000000000000..99999999999999999999) }
  end
end
