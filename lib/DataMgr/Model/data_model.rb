require 'json'

module DataMgr

  class DataModel
    attr_accessor :_file
    attr_accessor :app_model
    attr_accessor :debug

    def initialize(f=nil)
      @debug=false

      if !f.nil?
        @_file=f
        loadPages(@_file)
      end

    end

    def getAppModel()
      @app_model
    end

    def saveAs(_fname, _json)
      rc=false
      begin
        _f=File.open(_fname, 'w')
        _f.puts _json.to_json
        _f.close
        rc=true

      rescue => ex
        ;
      end
      rc
    end


    def loadPages(jlist)

      if jlist.nil? || jlist.empty?
        return nil
      end

      json_list=[]
      if jlist.kind_of?(String)
        json_list << jlist
      else
        json_list=jlist
      end

      jsonData={}
      json_list.each  { |f|

        begin

          _fd=nil
          _contents=nil
          _ext=File.extname(f)

          if _ext.match(/\.(yaml|yml|json|jsn)\s*$/i)
            _fd = File.open(f, 'r')
            _contents=_fd.read
            _fd.close

            _contents = JSON.dump(YAML::load(_contents)) if _ext.match(/(yaml|yml)/i)

            if !_contents.nil?
              data_hash = JSON.parse _contents
              jsonData.merge!(data_hash)
            end

          end

        rescue JSON::ParserError
          STDERR.puts " raise JSON::ParseError - #{f.to_s}"
          raise "JSONLoadError"

        rescue => ex
          STDERR.puts " Exception: #{ex.class}"
        end

      }
      puts "merged jsonData => " + jsonData.to_json  if @debug
      @app_model = jsonData
    end


    # getDataElement("data(address).get(city).get(zip)")
    def getDataElement(s)
      puts __FILE__ + (__LINE__).to_s + " getDataElement(#{s})" if @debug

      hit=@app_model

      nodes = s.split(/\./)

      nodes.each { |elt|

        puts __FILE__ + (__LINE__).to_s + " process #{elt}"
        getter = elt.split(/\(/)[0]
        _obj = elt.match(/\((.*)\)/)[1]

        puts __FILE__ + (__LINE__).to_s + " getter : #{getter}  obj: #{_obj}" if @debug

        if getter.downcase.match(/^\s*(getData)\s*/i)
          puts __FILE__ + (__LINE__).to_s + " -- process page --" if @debug
          hit=@app_model[_obj]
        elsif getter.downcase=='get'
          hit=hit[_obj]
        else
          puts __FILE__ + (__LINE__).to_s + " getter : #{getter} is unknown." if @debug
          return nil
        end
        puts __FILE__ + (__LINE__).to_s + " HIT => #{hit}" if @debug
      }

      hit
    end



    def hits(parent, h, condition, _action, pg)
      #  puts __FILE__ + (__LINE__).to_s + " collect_item_attributes(#{h})"
      result = []


      if h.is_a?(Hash)

        h.each do |k, v|
          puts __FILE__ + (__LINE__).to_s + " Key: #{k} => #{v}" if @debug
          if k == condition

            if !v.is_a?(Array) && v.match(/^\s*#{_action}\s*\((.*)\)\s*$/i)

              dataObject=v.match(/^\s*#{_action}\s*\((.*)\)\s*$/i)[1]

              if pg.nil?
                result << parent
              elsif pg == dataObject
                result << parent

              end

            elsif v.is_a?(Array)

              v.each do |vh|

                if vh.is_a?(Hash) && vh.has_key?(condition) && vh[condition].match(/^\s*#{_action}\s*/i)

                  pageObject=vh[condition].match(/^\s*#{_action}\s*\((.*)\)\s*$/i)[1]

                  if pg.nil?
                    result << parent
                  elsif pg == pageObject
                    result << parent
                  end

                end

              end

            end

          elsif v.is_a? Hash
            if parent.nil?
              _rc = hits("page(#{k})", h[k], condition, _action, pg)
            else
              _rc = hits("#{parent}.get(#{k})", h[k], condition, _action, pg)
            end

            if !(_rc.nil? || _rc.empty?)
              result << _rc
              result.flatten!
            end
          end
        end

      end

      result=nil if result.empty?
      puts __FILE__ + (__LINE__).to_s + " result : #{result}"  if @debug
      result
    end

  end



end
