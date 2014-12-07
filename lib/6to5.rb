require 'execjs'
require '6to5/source'

module JS6to5
  module Source
    def self.context
      @context ||= ExecJS.compile(<<-JS)
        #{File.read(path)}

        to5._transform = function() {
          var result = to5.transform.apply(this, arguments);
          return { code: result.code, map: result.map };
        }
      JS
    end
  end

  class << self
    def version
      Source.version
    end

    def transform(code, options = {})
      Source.context.call('to5._transform', code, options)
    end
  end
end
