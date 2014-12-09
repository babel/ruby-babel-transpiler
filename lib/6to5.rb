require 'execjs'
require '6to5/source'

module ES6to5
  module Source
    def self.version
      VERSION
    end

    def self.root
      ROOT
    end

    def self.path
      File.join(root, "6to5.js")
    end

    def self.polyfill_path
      File.join(root, "6to5/polyfill.js")
    end

    def self.runtime_path
      File.join(root, "6to5/runtime.js")
    end

    def self.context
      @context ||= ExecJS.compile(File.read(path))
    end
  end

  class << self
    def version
      Source.version
    end

    def transform(code, options = {})
      Source.context.call('to5.transform', code, options.merge('ast' => false))
    end
  end
end
