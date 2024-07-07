require "active_model"
require_relative "base_run"
require "securerandom"

module OpenInferenceRb
  module Instrumentation
    module Langchain
      module Tracers
        module Schemas
          class ToolRun < BaseRun
            field :tool_input, :string
            field :output, :string, default: nil
            field :action, :string
            field :child_llm_runs, default: []
            field :child_chain_runs, default: []
            field :child_tool_runs, default: []
          end
        end
      end
    end
  end
end
