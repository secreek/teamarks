require 'rubygems'
require 'bundler/setup'
require 'data_mapper'

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'Teamarks',
                 :author => 'GoF',
                 :url_base => 'http://localhost:4567/'
               )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  DataMapper.setup(:default, "sqlite:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db")

  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
end
