require "active_model"
require_relative "base_run"
require "securerandom"

module OpenInferenceRb
  module Instrumentation
    module Langchain
      module Tracers
        module Schemas
          class Run < BaseRun
            field :child_runs, default: []
            field :tags, default: []
            field :events, default: []
            field :trace_id, default: nil
            field :dotted_order, :string, default: nil

            validate :assign_name

            private

            def assign_name
              if name.nil?
                if serialized["name"]
                  self.name = serialized["name"]
                elsif serialized["id"]
                  self.name = serialized["id"][-1]
                end
              end
              self.events ||= []
            end
          end
        end
      end
    end
  end
end
