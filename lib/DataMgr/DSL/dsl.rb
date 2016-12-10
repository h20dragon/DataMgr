
require 'singleton'

module DataMgr

  class DSL
    include Singleton

    def initialize()

    end


    # Ex.  './spec/fixtures/connect.yml'
    def loadDB(_f)
      DataMgr::DB.instance.load(_f)
    end

    def cmd(opts)
#      puts "cmd => #{opts}"
      rc=false
      _cmd=nil

      if opts.has_key?(:cmd)
        _cmd=opts[:cmd]
      else
        return false
      end

      if _cmd.match(/^\s*loaddb\s*\(.*\)\s*$/i)
        dbName = _cmd.match(/^\s*loaddb\s*\((.*)\)\s*$/i)[1].to_s
        rc=DataMgr::DB.instance.load(dbName)

      elsif opts.has_key?(:cmd) && opts[:cmd].match(/^\s*connect\s*\((.*)\)\s*$/)
        _connectID = opts[:cmd].match(/^\s*connect\s*\((.*)\)\s*$/i)[1].to_s
        rc=DataMgr::DB.instance.connect(_connectID)

      elsif _cmd.match(/^\s*getDB\s*\(.*\)\.get\(.*\)\s*$/)
        db = _cmd.match(/^\s*getDB\s*\(\s*(.*)\s*\)\.get\(.*\)\s*$/)[1].to_s
#        puts "db => #{db}"
#        rc = queries.getDataElement(hit)
      else
        STDERR.puts " Unknown command: #{opts}"
      end


      rc

    end

    def connect(id)
      DataMgr::DB.instance.connect(id)
    end


    def loadData(_f)
      DataMgr::DataModel.new(_f)
    end






  end




end
