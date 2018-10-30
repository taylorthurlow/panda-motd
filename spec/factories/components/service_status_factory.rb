FactoryBot.define do
  factory :service_status do
    skip_create

    transient do
      settings { nil }
    end

    motd { association(:motd, components: [:service_status]) }

    initialize_with { new(motd) }

    after(:build) do |service_status|
      allow(service_status).to receive(:`).and_return ''
    end

    after(:create) do |service_status, evaluator|
      service_status.config.merge!(evaluator.settings) if evaluator.settings
    end
  end
end
