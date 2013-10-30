#!/usr/bin/env rake
$: << File.dirname(__FILE__)

require 'rubygems'

gem 'activesupport', '~> 3.0'

require "bundler/gem_tasks"
require 'rake/testtask'
require 'test/rails_helper'

desc "Run tests"
task :default => :test

Rails.application.load_tasks
