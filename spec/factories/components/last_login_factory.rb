FactoryBot.define do
  factory :last_login do
    skip_create

    transient do
      settings { nil }
    end

    motd { association(:motd, components: [:last_login]) }

    initialize_with { new(motd) }

    after(:build) do |last_login|
      allow(last_login).to receive(:`).and_return ''
    end

    after(:create) do |last_login, evaluator|
      last_login.config.merge!(evaluator.settings) if evaluator.settings
    end
  end
end
