#!/usr/bin/env ruby

require 'dotenv/load'
require 'faraday'
require 'chronic'
require 'JSON'

#
# MEMO:
# This script posts a request to management API
# c.f. https://developer.github.com/enterprise/2.14/v3/enterprise-admin/management_console/#enable-or-disable-maintenance-mode
#

HOST_PORT = ENV['HOST_PORT']
API_KEY = ENV['API_KEY']

maintenance_when = ARGV[0]

# validate the argument
raise 'invalid argument' unless Chronic.parse(maintenance_when)

# prompt to confirm
def check_prompt(prompt = 'Continue?')
  input = ''
  begin
    print "#{prompt} [yYnN]: "
    input = STDIN.gets.chomp
    exit(0) if input.empty?
  end while input !~ /^[YynN]$/
  exit(0) unless input.downcase == 'y'
  nil
end

check_prompt("Schedule a maintenance? when = '#{Chronic.parse(maintenance_when)}'")

conn = Faraday.new(url: "https://#{HOST_PORT}/") do |fd|
  fd.request :url_encoded
  fd.response :logger
  fd.adapter Faraday.default_adapter
end

res = conn.post do |req|
  req.url 'setup/api/maintenance'
  req.params['api_key'] = API_KEY
  req.body = { maintenance: JSON.generate(enabled: true, when: maintenance_when) }
end

puts res.body

