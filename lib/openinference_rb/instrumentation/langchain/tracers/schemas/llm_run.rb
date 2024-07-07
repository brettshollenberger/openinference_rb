require "active_model"
require_relative "base_run"
require "securerandom"

module OpenInferenceRb
  module Instrumentation
    module Langchain
      module Tracers
        module Schemas
          class LLMRun < BaseRun
            field :prompts, default: []
            field :response, default: nil
          end
        end
      end
    end
  end
end
