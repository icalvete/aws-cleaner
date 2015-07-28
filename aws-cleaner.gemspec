Gem::Specification.new do |s|
  s.name        = 'aws-cleaner'
  s.version     = '0.1.1'
  s.summary     = "AWS Cleaner cleans up after EC2 nodes are terminated"
  s.description = "A tool to clean up after EC2 nodes are terminated"
  s.authors     = ["Eric Heydrick"]
  s.email       = 'eheydrick@gmail.com'
  s.executables = ['aws_cleaner.rb']
  s.files       = ["bin/aws_cleaner.rb"]
  s.homepage    = 'https://github.com/eheydrick/aws-cleaner'
  s.license     = 'MIT'

  s.add_runtime_dependency 'aws-sdk-core', '~> 2.0'
  s.add_runtime_dependency 'chef-api', '~> 0.5'
  s.add_runtime_dependency 'hipchat', '~> 1.5'
  s.add_runtime_dependency 'rest-client', '~> 1.8'
end