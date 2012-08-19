# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'rubygems'

ENV['GEM_HOME']="~#{ENV['USER']}/.rvm/gems/ruby-1.9.2-p320@pbm"
ENV['GEM_PATH']="~#{ENV['USER']}/.rvm/gems/ruby-1.9.2-p320@pbm:~#{ENV['USER']}/.rvm/gems/ruby-1.9.2-p320@global"

require 'rubygems'
Gem.clear_paths

require 'bundler'
Bundler.require

run Pbm::Application
