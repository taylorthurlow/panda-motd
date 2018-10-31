FactoryBot.define do
  factory :motd, class: MOTD do
    skip_create

    transient do
      components { [] }
    end

    config { association(:config, components: components) }

    initialize_with { new(config.file_path, false) }
  end
end
