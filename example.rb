require "pry"
require "opentelemetry"
require "opentelemetry-api"
require "opentelemetry-sdk"
require "opentelemetry-instrumentation-base"
require "faraday"
require_relative "lib/openinference_rb"
require "ollama"
require "langchain"

require_relative "lib/openinference_rb/instrumentation/langchain/instrumentation"

OpenTelemetry::SDK.configure do |c|
  c.use "OpenInferenceRb::Instrumentation::Langchain"
end

model_name = "llama3"

model = Langchain::LLM::Ollama.new(
  url: "http://127.0.0.1:11434",
  default_options: {
    completion_model_name: model_name,
    chat_completion_model_name: model_name,
    temperature: 0
  }
)

output = model.chat(messages: [{
                      role: "user",
                      content: %(Who was the first president of the United State?),
                      format_instructions: "Do whatever you want"
                    }])

puts output.raw_response.dig("message", "content")
