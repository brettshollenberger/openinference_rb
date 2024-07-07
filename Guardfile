guard :rspec, cmd: "bundle exec rspec" do
  watch(%r{^spec/.+_spec\.rb$}) { |_m| "spec/openinference_rb/instrumentation/patches/llm_spec.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |_m| "spec/openinference_rb/instrumentation/patches/llm_spec.rb" }
end
