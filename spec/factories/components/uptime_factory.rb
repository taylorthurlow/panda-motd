FactoryBot.define do
  factory :uptime do
    skip_create

    transient do
      settings { nil }
    end

    motd { association(:motd, components: [:uptime]) }

    initialize_with { new(motd) }

    after(:build) do |uptime|
      allow(uptime).to receive(:`).and_return ''
    end

    after(:create) do |uptime, evaluator|
      uptime.config.merge!(evaluator.settings) if evaluator.settings
    end
  end
end
