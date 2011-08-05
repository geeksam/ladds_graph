Dir.glob(File.join(File.dirname(__FILE__), '*_tests.rb')).each do |test_suite|
  require test_suite
end
