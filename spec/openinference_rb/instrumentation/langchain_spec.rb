require "parallel"
require "json"
require "logger"
require "langchain"
require "ollama"
require "httpx"
require "opentelemetry/sdk"
require "opentelemetry/semantic_conventions"
require "webmock/rspec"

RSpec.describe "OpenInferenceRb::Instrumentation::Langchain" do
  let(:instrumentation) { OpenInferenceRb::Instrumentation::Langchain::Instrumentation.instance }
  let(:minimum_version) { OpenInferenceRb::Instrumentation::Langchain::Instrumentation::MINIMUM_VERSION }

  it "has #name" do
    expect(instrumentation.name).to eq "OpenInferenceRb::Instrumentation::Langchain"
  end

  it "has #version" do
    expect(instrumentation.version).to_not be_nil
    expect(instrumentation.version).to_not be_empty
  end

  describe "compatible" do
    it "when a version below the minimum supported gem version is installed" do
      allow(instrumentation).to receive(:gem_version).and_return("0.13.4")
      expect(instrumentation.compatible?).to eq false
    end

    it "when supported gem version installed" do
      expect(instrumentation.compatible?).to eq true
    end
  end

  describe "#install" do
    it "accepts argument" do
      expect(instrumentation.install({})).to eq true
    end
  end

  # let(:logger) { Logger.new(STDOUT) }
  # let(:n) { 10 }
  # let(:questions) { Array.new(n) { randstr } }
  # let(:langchain_template) { "{context}{question}" }
  # let(:langchain_prompt) do
  #   Langchain::PromptTemplate.new(input_variables: %w[context question], template: langchain_template)
  # end
  # let(:url) { "https://api.openai.com/v1/chat/completions" }
  # let(:model_name) { "llama3" }
  # let(:completion_usage) { "???" }
  # let(:chat_model) do
  #   Langchain::LLM::Ollama.new(
  #     url: "http://127.0.0.1:11434",
  #     default_options: {
  #       completion_model_name: model_name,
  #       chat_completion_model_name: model_name,
  #       temperature: 0
  #     }
  #   )
  # end
  # before do
  #   stub_request(:post, "https://api.openai.com/v1/chat/completions")
  #     .to_return(status: 200, body: {
  #       choices: [{ index: 0, message: { role: "user", content: "response" }, finish_reason: "stop" }],
  #       model: "gpt-3.5-turbo",
  #       usage: { total_tokens: 10, prompt_tokens: 5, completion_tokens: 5 }
  #     }.to_json, headers: { "Content-Type" => "application/json" })
  # end

  # allow_any_instance_of(Langchain::LLM::OpenAI).to receive(:complete).
  #   and_return(mock_llm_response("decline"))

  # let(:retriever) do
  #   Langchain::Retrievers::KNNRetriever.new(index: Matrix.build(documents.size, 2) do
  #                                                    1.0
  #                                                  end, texts: documents, embeddings: Langchain::Embeddings::FakeEmbeddings.new(size: 2))
  # end
  # let(:rqa) do
  #   Langchain::Chains::RetrievalQA.from_chain_type(llm: chat_model, retriever: retriever,
  #                                                  chain_type_kwargs: { prompt: langchain_prompt })
  # end

  # def randstr
  #   (0...8).map { rand(65..90).chr }.join
  # end

  # def chat_completion_mock_stream
  #   [[StringIO.new("stream data")], [{ "role" => "system", "content" => "mock message" }]]
  # end

  # before do
  #   logger.level = Logger::DEBUG
  #   OpenTelemetry.logger = logger
  #   OpenTelemetry.tracer_provider = OpenTelemetry::SDK::Trace::TracerProvider.new
  #   @in_memory_span_exporter = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new
  #   span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(@in_memory_span_exporter)
  #   OpenTelemetry.tracer_provider.add_span_processor(span_processor)
  # end

  # [
  #   [false, true], [true, false]
  # ].each do |is_async, is_stream|
  #   [200, 400].each do |status_code|
  #     [false, true].each do |use_context_attributes|
  #       it "tests callback_llm with async=#{is_async}, stream=#{is_stream}, status_code=#{status_code}, context_attributes=#{use_context_attributes}" do
  #         output_messages = is_stream ? chat_completion_mock_stream[1] : [{ "role" => randstr, "content" => randstr }]
  #         respx_kwargs = if is_stream
  #                          { body: StringIO.new(chat_completion_mock_stream[0].join) }
  #                        else
  #                          { json: { choices: output_messages.each_with_index.map do |message, i|
  #                                               { index: i, message: message, finish_reason: "stop" }
  #                                             end, model: model_name, usage: completion_usage } }
  #                        end
  #         stub_request(:post, url).to_return(status: status_code, body: respx_kwargs.to_json)

  #         main = proc do
  #           if is_async
  #             Parallel.each(questions, threads: questions.count) do |question|
  #               rqa.ainvoke(query: question)
  #             end
  #           else
  #             questions.each do |question|
  #               rqa.invoke(query: question)
  #             end
  #           end
  #         end

  #         if use_context_attributes
  #           # OpenTelemetry.context.with_values(
  #           #   session_id: session_id,
  #           #   user_id: user_id,
  #           #   metadata: metadata,
  #           #   tags: tags,
  #           #   prompt_template: prompt_template,
  #           #   prompt_template_version: prompt_template_version,
  #           #   prompt_template_variables: prompt_template_variables
  #           # ) { main.call }
  #         else
  #           main.call
  #         end

  #         spans = @in_memory_span_exporter.finished_spans
  #         traces = spans.group_by { |span| span.context.trace_id }

  #         expect(traces.size).to eq(n)
  #         traces.values.each do |spans_by_name|
  #           rqa_span = spans_by_name.find { |span| span.name == "RetrievalQA" }
  #           expect(rqa_span).not_to be_nil
  #           expect(rqa_span.parent).to be_nil
  #         end
  #       end
  #     end
  #   end
  # end
end
