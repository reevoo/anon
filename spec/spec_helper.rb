require 'simplecov'
SimpleCov.start

def capture_stdout
  real_stdout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = real_stdout
end
