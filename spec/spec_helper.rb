# -*- encoding : utf-8 -*-
require 'rubygems'
require 'rspec/autorun'
require 'fileutils'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.expect_with(:rspec) { |e| e.syntax = :expect }
  config.mock_with(:rspec) { |m| m.syntax = :expect }

  config.color_enabled = true
  config.tty = true
  config.formatter = 'documentation'
  config.order = 'random'

  # Add helpers for dealing with Vagrant
  config.include VagrantSshHelper
end
