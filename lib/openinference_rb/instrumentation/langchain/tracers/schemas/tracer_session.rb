require "active_model"
require_relative "base_model"
require "securerandom"

module OpenInferenceRb
  module Instrumentation
    module Langchain
      module Tracers
        module Schemas
          class TracerSession < BaseModel
            field :id, :integer, default: -> { SecureRandom.uuid }
            field :tenant_id, default: -> { SecureRandom.uuid }
          end
        end
      end
    end
  end
end
