#!/usr/bin/ruby

require 'json'
require 'yaml'
require 'rest-client'
require 'trollop'
#require 'fluzo_log'
require 'timeout'
require 'pp'

# Main variables
debug = false
fake_nodes = [
  'i-02b4811e4833b011d',
  'i-051da8d51881d37a5',
  'i-096ab017fdc705637',
  'i-0a447495d3e76c9b2',
  'i-0d9f627db3c36ea80',
]

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

# Log init
=begin
$logger = Fluzo::SyslogLog.new('sensu-cleaner')
$logger.set_operation_id process_id
$logger.set_operation("cleaner")
$logger.send 'Start'
=end


@config = config(opts[:config])

while true
  fake_nodes.each do |fake_node|
    if AwsCleaner::Sensu.in_sensu?(fake_node, @config)
      puts "#{fake_node} is in sensu."
      AwsCleaner::Sensu.remove_from_sensu(fake_node, @config)
      puts "#{fake_node} has been deleted from sensu."
    else
    end
  end
  sleep(2)
end
