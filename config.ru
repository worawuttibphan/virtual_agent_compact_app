$LOAD_PATH << File.dirname(__FILE__)
require 'rubygems' unless defined? ::Gem
require File.dirname( __FILE__ ) + '/lib/server'

run Sinatra::Application
