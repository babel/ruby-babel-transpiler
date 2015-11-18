require 'execjs'
require 'babel/source'
require 'babel/transpiler/version'

module Babel
  module Transpiler
    def self.version
      VERSION
    end

    def self.source_version
      Source::VERSION
    end

    def self.source_path
      Source::PATH
    end

    def self.script_path
      File.join(source_path, "babel.js")
    end

    def self.context
      script_header = <<-EOS
        var self = this;
        // including console implementation for ExecJS environment
        var console = (function (){
          var buffer = [];
          function getBuffer() { return buffer.concat(); }
          function clearBuffer() { buffer = []; }
          function writeToBuffer(level, args) {
            buffer.push(level + ": " + Array.prototype.join.call(args, ', '));
          }
          function log() { writeToBuffer('LOG', arguments); }
          function error() { writeToBuffer('ERROR', arguments); }
          function debug() { writeToBuffer('DEBUG', arguments); }
          function info() { writeToBuffer('INFO', arguments); }
          return {
            log:log,
            error:error,
            debug:debug,
            info:info,
            getBuffer:getBuffer,
            clearBuffer:clearBuffer
          };
        })();
      EOS

      @context ||= ExecJS.compile(script_header + File.read(script_path))
    end

    def self.transform(code, options = {})
      context.call('console.clearBuffer')
      context.call('babel.transform', code, options.merge('ast' => false))
    end

    def self.console_output
      context.call('console.getBuffer')
    end
  end
end
