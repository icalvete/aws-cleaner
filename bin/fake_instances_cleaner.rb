#!/usr/bin/ruby

require 'json'
require 'yaml'
require 'rest-client'
require 'trollop'
require 'timeout'
require 'pp'

# Main variables
#debug = false

# require our class
require_relative '../lib/aws-cleaner.rb'

def config(file)
  YAML.safe_load(File.read(File.expand_path(file)), [Symbol])
rescue StandardError => e
  raise "Failed to open config file: #{e}"
end

# get options
opts = Trollop.options do
  opt :config, 'Path to config file', type: :string, default: 'config.yml'
end

@config = config(opts[:config])
fake_instances = @config[:fake_instances]

loop do
  fake_instances.each do |fake_instance|
    if AwsCleaner::Sensu.in_sensu?(fake_instance, @config)
      puts "#{fake_instance} is in sensu."
      AwsCleaner::Sensu.remove_from_sensu(fake_instance, @config)
      puts "#{fake_instance} has been deleted from sensu."
    else
    end
  end
  sleep(2)
end
