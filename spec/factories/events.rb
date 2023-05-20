FactoryBot.define do
  factory :event do
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    date { Faker::Date.forward(days: 30) }
    organizer { association(:user) }

    trait :finalized do
      location { association(:location) }
    end
  end
end
