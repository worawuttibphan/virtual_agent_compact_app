require_relative 'test_helper'
require 'tilt/erubis'
ENV['RACK_ENV'] = 'test'
require 'rack/test'

class ServerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    AmiVoice::DialogModule::Web
  end

  def test_main
    get "/main.vxml"
    assert last_response.ok?
  end

  def test_root
    get "/root.vxml"
    assert last_response.ok?
  end
end
