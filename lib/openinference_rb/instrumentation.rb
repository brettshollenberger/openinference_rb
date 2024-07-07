module OpenInferenceRb
  module Instrumentation
  end
end

Dir.glob(File.expand_path("instrumentation/**/instrumentation.rb", __dir__)).each do |f|
  puts "Requiring #{f}"
  require_relative f
end
