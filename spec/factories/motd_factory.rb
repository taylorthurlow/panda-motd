FactoryBot.define do
  factory :motd, class: MOTD do
    skip_create

    config { association(:config) }

    initialize_with { new(config.file_path, false) }
  end
end
