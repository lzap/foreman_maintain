module ForemanMaintain
  class Scenario
    include Concerns::Logger
    include Concerns::SystemHelpers
    include Concerns::Metadata
    include Concerns::Finders

    attr_reader :steps

    class ChecksScenario < Scenario
      metadata do
        manual_detection
      end
      attr_reader :filter_tags

      def initialize(filter_tags)
        @filter_tags = filter_tags
        @steps = ForemanMaintain.available_checks(:tags => filter_tags).map(&:ensure_instance)
      end

      def description
        "checks with tags #{tag_string(@filter_tags)}"
      end

      private

      def tag_string(tags)
        tags.map { |tag| "[#{tag}]" }.join(' ')
      end
    end

    def initialize
      @steps = []
      compose
    end

    # Override to compose steps for the scenario
    def compose; end

    def add_steps(steps)
      steps.each do |step|
        self.steps << step.ensure_instance
      end
    end

    def add_step(step)
      add_steps([step])
    end

    def self.inspect
      "Scenario Class #{metadata[:description]}<#{name}>"
    end

    def inspect
      "#{self.class.metadata[:description]}<#{self.class.name}>"
    end
  end
end
