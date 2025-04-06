FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    description { "This is a test project description" }
    status { :created }
  end
end
