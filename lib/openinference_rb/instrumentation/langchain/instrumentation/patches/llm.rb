module OpenInferenceRb
  module Instrumentation
    module Langchain
      class Instrumentation < OpenTelemetry::Instrumentation::Base
        module Patches
          module LLM
            def chat(messages:, model: nil, **params, &block)
              tracer.in_span('Langchain::LLM::Ollama.chat') do |span|
                begin
                  # Set relevant attributes
                  span.set_attribute('llm.model', model || defaults[:chat_completion_model_name])
                  span.set_attribute('llm.messages.count', messages.size)

                  parameters = chat_parameters.to_params(params.merge(messages:, model:, stream: block.present?))
                  responses_stream = []

                  client.post("api/chat", parameters) do |req|
                    req.options.on_data = json_responses_chunk_handler do |parsed_chunk|
                      responses_stream << parsed_chunk

                      block&.call(OllamaResponse.new(parsed_chunk, model: parameters[:model]))
                    end
                  end

                  result = generate_final_chat_completion_response(responses_stream, parameters)
                  span.set_attribute('http.status_code', 200) # assuming the response was successful
                  result
                rescue => e
                  span.record_exception(e)
                  span.set_status(OpenTelemetry::Trace::Status.error("Unhandled exception of type: #{e.class}"))
                  raise
                end
              end
            end

            private

            def tracer
              OpenInferenceRb::Instrumentation::Langchain::Instrumentation.instance.tracer
            end
          end
        end
      end
    end
  end
end
