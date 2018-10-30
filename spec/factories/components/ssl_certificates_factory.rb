FactoryBot.define do
  factory :ssl_certificates, class: SSLCertificates do
    skip_create

    transient do
      settings { nil }
    end

    motd { association(:motd, components: [:ssl_certificates]) }

    initialize_with { new(motd) }

    after(:build) do |ssl_certificates|
      allow(ssl_certificates).to receive(:`).and_return ''
    end

    after(:create) do |ssl_certificates, evaluator|
      ssl_certificates.config.merge!(evaluator.settings) if evaluator.settings
    end
  end
end
