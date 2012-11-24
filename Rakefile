#!/usr/bin/env rake
$: << File.dirname(__FILE__)

require "bundler/gem_tasks"
require 'rake/testtask'
require 'test/rails_helper'

# Rake::TestTask.new do |t|
#   t.libs << 'test'
#   t.test_files = FileList['test/functional/*_test.rb']
# end
# 
desc "Run tests"
task :default => :test

Rails.application.load_tasks
