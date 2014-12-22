#!/usr/bin/ruby
require 'rubygems'
require 'json'

json = File.read('/etc/puppet/modules/bootstrap_puppet/metadata.json')
obj = JSON.parse(json)

obj["dependencies"].each do |dep|
  @note = 'Installing dependency'
  @depname = dep["name"].sub '/', '-'
  @cmd = "puppet module install #{@depname}"
  puts "#{@cmd}"
  exec("#{@cmd}")
end

