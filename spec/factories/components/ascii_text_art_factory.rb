FactoryBot.define do
  factory :ascii_text_art, class: ASCIITextArt do
    skip_create

    transient do
      settings { nil }
    end

    motd { association(:motd, components: [:ascii_text_art]) }

    initialize_with { new(motd) }

    after(:build) do |ascii_text_art|
      allow(ascii_text_art).to receive(:`).and_return ''
    end

    after(:create) do |ascii_text_art, evaluator|
      ascii_text_art.config.merge!(evaluator.settings) if evaluator.settings
    end
  end
end
