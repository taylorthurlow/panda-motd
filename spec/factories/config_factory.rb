require 'yaml'

FactoryBot.define do
  factory :config do
    skip_create

    config_number = SecureRandom.hex(10)

    transient do
      components { [] }
    end

    file_path { "tmp/config#{config_number}" }

    before(:create) do |_config, evaluator|
      if evaluator.components.any?
        component_hash = {}
        component_hash['components'] = evaluator.components
                                                .map { |ec| "spec/fixtures/configs/#{ec}.yaml" }
                                                .map { |y| YAML.safe_load(File.read(y))['components'] }
                                                .reduce(&:merge) # grab each config and merge into one yaml
        File.open("tmp/config#{config_number}", 'w') { |f| f.write component_hash.to_yaml }
      end
    end

    initialize_with { new(file_path) }
  end
end
