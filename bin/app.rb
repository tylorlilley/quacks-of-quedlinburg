#!/usr/bin/env ruby
require_relative '../lib/environment'

raise 'Usage: repo=octokit.py bin/app.rb' unless ENV['repo']

puts Main.new(ENV['repo']).run
