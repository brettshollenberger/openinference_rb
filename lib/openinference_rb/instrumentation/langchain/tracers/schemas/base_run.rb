require "active_model"
require_relative "base_model"
require "securerandom"

module OpenInferenceRb
  module Instrumentation
    module Langchain
      module Tracers
        module Schemas
          class BaseRun < BaseModel
            field :uuid, default: -> { SecureRandom.uuid }
            field :parent_uuid, :string, default: nil
            field :start_time, default: -> { Time.now.utc }
            field :end_time, default: -> { Time.now.utc }
            field :extra, default: nil
            field :execution_order, :integer
            field :child_execution_order, :integer
            field :serialized, default: {}
            field :session_id, :integer
            field :error, :string, default: nil
          end
        end
      end
    end
  end
end
