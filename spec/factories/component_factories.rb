# typed: true
# frozen_string_literal: true

Dir["#{PandaMOTD.root}/lib/panda_motd/components/**/*.rb"].each do |c|
  component_sym = File.basename(c, ".rb").to_sym
  klass = Config.component_classes[component_sym]

  FactoryBot.define do
    factory component_sym, class: klass do
      skip_create

      transient do
        settings { nil }
      end

      motd { association(:motd, components: [component_sym]) }

      initialize_with { new(motd) }

      after(:build) do |component|
        allow(component).to receive(:`).and_return ""
      end

      after(:create) do |component, evaluator|
        component.config.merge!(evaluator.settings) if evaluator.settings
      end
    end
  end
end
