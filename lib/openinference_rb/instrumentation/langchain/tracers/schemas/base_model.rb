# frozen_string_literal: true

require "active_model"

module OpenInferenceRb
  module Instrumentation
    module Langchain
      module Tracers
        module Schemas
          class BaseModel
            include ActiveModel::Model
            include ActiveModel::Attributes

            def self.field(name, **options)
              attribute(name, **options)
            end
          end
        end
      end
    end
  end
end
