require 'json'
module Pisec
  class Settings

    def self.load_file yaml, into
      _data = _parse_file( yaml )
      load( _data, into )
    end

    def self.load _data, into=nil
      opts = {}
      opts[:namespace] = into if into
      new( _data, opts )
    end

    class << self
      #def source_file yaml, into
      #  _data = _parse_source( yaml, into )
      #  load( _data, into )
      #end

      #def _parse_source( yaml, namespace )
      #  `source #{yaml}`
      #  ENV.select{|k,v| k.upcase =~ /^#{into.upcase}\_/}
      #end
      #private :_parse_source

      def _open_file( file_name )
        File.open( file_name, "r" )
      end
      private :_open_file

      def _parse_file( yaml )
        data_hash = {}
        yaml_io = _open_file( yaml )
        while !yaml_io.eof?
          l = yaml_io.readline
          next if l.match(/^\s*#/)
            m = l.chomp.match(/^\s*export\s+(.+)$/)
          next unless m && m[1]
          kv = m[1].split(/=/)
          #puts "got kv: #{kv.inspect}"
          hash_key = kv.first
          hash_value = JSON.parse(eval(kv.last))
          data_hash[hash_key] = hash_value
        end
        return data_hash
      ensure
        yaml_io.close if yaml_io.respond_to?(:close)
      end
      private :_parse_file
    end

    attr_reader :namespace, :data
    def initialize( _data = {}, args = {} )
      @namespace = args[:namespace].to_s || ''
      load( _data )
    end

    def ==(other)
      ( other.namespace == self.namespace ) &&
        ( other.data == self.data )
    end

    def load _data
      if _data.respond_to?(:[])
        @data = _data
      else
        fail(RuntimeError)
      end
    end

    def get key='', _namespace = namespace
      result = nil
      if data && hash = data[_env_key_for(key, _namespace)]
        if hash.respond_to?(:[])
          result = hash[ key ]
        end
      end
      result || fail(RuntimeError)
    end

    private

    def _env_key_for key='', _namespace = namespace
      "#{_namespace}_#{key}".upcase
    end
  end
end
