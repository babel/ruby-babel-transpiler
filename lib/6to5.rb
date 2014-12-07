require 'execjs'
require '6to5/source'

module JS6to5
  module Source
    def self.version
      VERSION
    end

    def self.root
      ROOT
    end

    def self.path
      PATH
    end

    def self.polyfill_path
      POLYFILL_PATH
    end

    def self.runtime_path
      RUNTIME_PATH
    end

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
