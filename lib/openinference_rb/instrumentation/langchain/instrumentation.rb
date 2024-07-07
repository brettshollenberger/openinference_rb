# frozen_string_literal: true

require "opentelemetry/instrumentation"
require "opentelemetry-registry"
require_relative "instrumentation/patches/llm"

module OpenInferenceRb
  module Instrumentation
    module Langchain
      # The Instrumentation class contains logic to detect and install the Langchain instrumentation
      class Instrumentation < OpenTelemetry::Instrumentation::Base
        MINIMUM_VERSION = Gem::Version.new("0.13.5")

        install do |_config|
          require_dependencies
          patch
        end

        present do
          defined?(::Langchain)
        end

        compatible do
          gem_version >= MINIMUM_VERSION
        end

        private

        def gem_version
          ::Langchain::VERSION
        end

        def patch
          puts "Patching Langchain LLM"
          # ::Langchain::LLM::Base.prepend(Patches::LLM)
          llms.each do |llm|
            llm.prepend(Patches::LLM)
          end
        end

        def llms
          ::Langchain::LLM.constants.map do |const|
            ::Langchain::LLM.const_get(const)
          end.select do |klass|
            klass.ancestors.include?(::Langchain::LLM::Base)
          end
        end

        def require_dependencies
          require_relative "instrumentation/patches/llm"
        end
      end
    end
  end
end

OpenTelemetry::Instrumentation::Registry.new.register(OpenInferenceRb::Instrumentation::Langchain::Instrumentation)
