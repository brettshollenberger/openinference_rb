# frozen_string_literal: true

require_relative "lib/openinference_rb/version"

Gem::Specification.new do |spec|
  spec.name = "openinference_rb"
  spec.version = OpeninferenceRb::VERSION
  spec.authors = ["Brett Shollenberger"]
  spec.email = ["brettshollenberger@Bretts-MacBook-Pro-2.local"]

  spec.summary = "OpenInference port for Ruby"
  spec.description = "OpenInference port for Ruby"
  spec.homepage = "https://github.com/brettshollenberger/openinference_rb.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "langchainrb"
  spec.add_dependency "opentelemetry-api"
  spec.add_dependency "opentelemetry-exporter-otlp"
  spec.add_dependency "opentelemetry-instrumentation-base"
  spec.add_dependency "opentelemetry-registry"
  spec.add_dependency "opentelemetry-sdk"
end
