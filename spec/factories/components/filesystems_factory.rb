FactoryBot.define do
  factory :filesystems do
    skip_create

    transient do
      settings { nil }
    end

    motd { association(:motd, components: [:filesystems]) }

    initialize_with { new(motd) }

    after(:build) do |filesystems|
      allow(filesystems).to receive(:`).and_return ''
    end

    after(:create) do |filesystems, evaluator|
      filesystems.config.merge!(evaluator.settings) if evaluator.settings
    end
  end
end
