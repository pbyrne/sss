require 'sss'

RSpec.configure do |config|
  config.before(:suite) do
    set_up_test_directories
  end
end

def set_up_test_directories
  system "mkdir -p spec/support/workspace/project1/.git"
  system "mkdir -p spec/support/workspace/project2/.hg"
  system "mkdir -p spec/support/workspace/project3/.svn"
end
