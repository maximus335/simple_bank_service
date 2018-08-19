FactoryBot.define do
  factory :account, class: 'Account' do
    number { create(:number) }
  end
end
