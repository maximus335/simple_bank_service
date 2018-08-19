# Фабрика значений
FactoryBot.define do
  sequence(:uniq)

  factory :number, class: String do
    skip_create
    initialize_with { '40702840' + Time.now.strftime("%s%2N") }
  end
end
