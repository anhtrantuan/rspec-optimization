FactoryGirl.define do
  factory :note do
    title   Faker::Lorem.sentence
    content Faker::Lorem.paragraph
    starred [true, false].sample
    read    [true, false].sample

    factory :starred_note do
      starred true
    end

    factory :unstarred_note do
      starred false
    end

    factory :read_note do
      read true
    end

    factory :unread_note do
      read false
    end
  end
end
