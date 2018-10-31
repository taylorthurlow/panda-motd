Dir["#{PandaMOTD.root}/lib/panda_motd/components/**/*.rb"].each do |c|
  component = File.basename(c, '.rb').to_sym
  klass = Config.component_classes[component]

  FactoryBot.define do
    factory component, class: klass do
      skip_create

      transient do
        settings { nil }
      end

      motd { association(:motd, components: [component]) }

      initialize_with { new(motd) }

      after(:build) do |component|
        allow(component).to receive(:`).and_return ''
      end

      after(:create) do |component, evaluator|
        component.config.merge!(evaluator.settings) if evaluator.settings
      end
    end
  end
end
