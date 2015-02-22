require 'json'
require 'rack/request'

module App
  USER = ENV['USER'] || fail("USER not set")
  TOKEN = ENV['TOKEN'] || fail("TOKEN not set")

  def self.call(env)
    request = Rack::Request.new(env)
    payload = JSON.parse(request.body.read)

    if payload["ref"] && (version = payload["ref"][/(\d+\.\d+\.\d+)/, 1])
      system "pr-release", USER, TOKEN, version
      fail "pr-release failed" unless $?.success?
    end

    [200, {'Content-Type' => 'text/plain'}, []]
  end
end

run App
