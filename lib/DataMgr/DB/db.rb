#
# QA Engineering
# All Rights Reserved 2016
#
require 'singleton'
require 'yaml'

module DataMgr

  class DB
    include Singleton

    attr_accessor :clients
    attr_accessor :config

    def initialize
      @clients={}
    end

    def close(_id)
      disconnect(_id)
    end

    def disconnect(_id)
      rc=false
      if @clients.has_key?(_id)
        @clients[_id].close
        rc=true
      end
      rc
    end


    def connect(_id)
      rc=false
      begin
        conn=get(_id)

        if !conn.nil?
          @clients[_id] = TinyTds::Client.new username: conn['user'],
                                       password: conn['password'],
                                       host: conn['host'],
                                       port: conn['port']
          rc=true if @clients[_id].active?
        else
          puts __FILE__ + (__LINE__).to_s + " WARN: client #{_id} is not defined."
        end

      rescue => ex
        ;
      end

      rc
    end


    def get(_id)
      @config.each do |_c|
        puts __FILE__ + (__LINE__).to_s + " get => #{_c}"
        if _c.has_key?(_id)
          return _c[_id]
        end
      end

      nil
    end


    def load(_config)
      rc=false
      begin
        @config=YAML.load_stream File.read(_config)
        rc=true
      rescue => ex
        puts __FILE__ + (__LINE__).to_s + " #{ex.class}: Invalid file: #{_config} - abort processing."
        puts ex.backtrace
      end
      rc
    end

  end



end
