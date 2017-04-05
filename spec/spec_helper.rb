require 'rack/test'
require 'rspec'
require 'pony'
require 'email_spec'
require 'email_spec/rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app
    @app ||= App
  end
end

RSpec.configure { |c| c.include RSpecMixin }
