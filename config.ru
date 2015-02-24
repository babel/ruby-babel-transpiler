require 'json'
require 'rack/request'
require 'shellwords'

Dir.chdir(__dir__)

module App
  USER = ENV['USER'] || fail("USER not set")
  TOKEN = ENV['TOKEN'] || fail("TOKEN not set")

  def self.call(env)
    request = Rack::Request.new(env)
    payload = JSON.parse(request.body.read)

    if payload["ref"] && (version = payload["ref"][/(\d+\.\d+\.\d+)/, 1])
      output = `#{__dir__}/pr-release #{Shellwords.join([USER, TOKEN, version])} 2>&1`
      fail "pr-release failed:\n#{output}" unless $?.success?
    end

    [200, {'Content-Type' => 'text/plain'}, []]
  end
end

run App
