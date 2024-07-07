# frozen_string_literal: true

require "openinference_rb"
require "opentelemetry-sdk"
require "pry"

Dir.glob(File.expand_path("support/**/*.rb", __dir__)).each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.include LangchainHelpers

  EXPORTER = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new
  span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(EXPORTER)
  config.before(:suite) do
    OpenTelemetry::SDK.configure do |c|
      c.use "OpenInferenceRb::Instrumentation::Langchain"
      c.error_handler = ->(exception:, message:) { raise(exception || message) }
      c.logger = Logger.new($stderr, level: ENV.fetch("OTEL_LOG_LEVEL", "fatal").to_sym)
      c.add_span_processor span_processor
    end
  end
end
