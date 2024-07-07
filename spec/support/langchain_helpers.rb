module LangchainHelpers
  def mock_llm_response(message)
    Langchain::LLM::OpenAIResponse.new(
      {
        "choices": [
          {
            "message": {
              "content": message
            }.with_indifferent_access
          }.with_indifferent_access
        ]
      }.with_indifferent_access
    )
  end

  def chat_response(content: nil, type: "openai")
    case type
    when "openai"
      {
        "choices": [
          {
            "message": {
              "content": content
            }.with_indifferent_access
          }.with_indifferent_access
        ]
      }.with_indifferent_access
    when "ollama"
      {
        "message": {
          "content": content
        }
      }
    end
  end

  def embeddings_response
    {
      "data": [
        {
          "embedding": [0.1, 0.2, 0.3],
          "index": 0
        }
      ]
    }
  end

  def mock_openai_response(endpoint: "api/chat", response_body: {})
    stub_request(:post, endpoint)
      .to_return(status: 200, body: response_body.to_json, headers: { "Content-Type" => "application/json" })
  end

  def mock_ollama_response(endpoint: "api/chat", response_body: {})
    url = "127.0.0.1:11434"
    full_url = URI.join("http://#{url}", endpoint)
    stub_request(:post, full_url)
      .to_return(status: 200, body: chat_response(
        content: response_body.to_json,
        type: "ollama"
      ).to_json, headers: { "Content-Type" => "application/json" })
  end
end
