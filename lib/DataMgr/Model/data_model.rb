require 'json'

module DataMgr

  class DataModel
    attr_accessor :_file
    attr_accessor :app_model

    def initialize(f=nil)

      if !f.nil?
        @_file=f
        loadPages(@_file)
      end

    end

    def getAppModel()
      @app_model
    end

    def saveAs(_fname, _json)
      _f=File.open(_fname, 'w')
      _f.puts _json.to_json
      _f.close
    end

    def loadPages(jlist)

      json_list=[]
      if jlist.kind_of?(String)
        json_list << jlist
      else
        json_list=jlist
      end

      jsonData={}
      json_list.each  { |f|
        puts __FILE__ + (__LINE__).to_s + " JSON.parse(#{f})"

        begin
          data_hash = JSON.parse File.read(f)
          jsonData.merge!(data_hash)
        rescue JSON::ParserError
          Scoutui::Logger::LogMgr.instance.fatal "raise JSON::ParseError - #{f.to_s}"
          raise "JSONLoadError"
        end

      }
      puts "merged jsonData => " + jsonData.to_json
      @app_model = jsonData
    end


    # getDataElement("data(address).get(city).get(zip)")
    def getDataElement(s)
      puts __FILE__ + (__LINE__).to_s + " getDataElement(#{s})"

      hit=@app_model

      nodes = s.split(/\./)

      nodes.each { |elt|

        puts __FILE__ + (__LINE__).to_s + " process #{elt}"
        getter = elt.split(/\(/)[0]
        _obj = elt.match(/\((.*)\)/)[1]

        puts __FILE__ + (__LINE__).to_s + " getter : #{getter}  obj: #{_obj}"

        if getter.downcase.match(/^\s*(getData)\s*/i)
          puts __FILE__ + (__LINE__).to_s + " -- process page --"
          hit=@app_model[_obj]
        elsif getter.downcase=='get'
          hit=hit[_obj]
        else
          puts __FILE__ + (__LINE__).to_s + " getter : #{getter} is unknown."
          return nil
        end
        puts __FILE__ + (__LINE__).to_s + " HIT => #{hit}"
      }

      hit
    end



    def hits(parent, h, condition, _action, pg)
      #  puts __FILE__ + (__LINE__).to_s + " collect_item_attributes(#{h})"
      result = []


      if h.is_a?(Hash)

        h.each do |k, v|
          puts __FILE__ + (__LINE__).to_s + " Key: #{k} => #{v}"
          if k == condition
            #  h[k].each {|k, v| result[k] = v } # <= tweak here
            if !v.is_a?(Array) && v.match(/^\s*#{_action}\s*\((.*)\)\s*$/i)

              dataObject=v.match(/^\s*#{_action}\s*\((.*)\)\s*$/i)[1]

              puts __FILE__ + (__LINE__).to_s + " <pg, pageObject> : <#{pg}, #{dataObject}>"
              #         result[k] = v

              #          puts '*******************'
              #          puts __FILE__ + (__LINE__).to_s + " HIT : #{h[k]}"
              #          result << { h[k] => v }

              if pg.nil?
                result << parent
              elsif pg == dataObject
                result << parent

              end

            elsif v.is_a?(Array)

              v.each do |vh|
                puts " =====> #{vh}"

                if vh.is_a?(Hash) && vh.has_key?(condition) && vh[condition].match(/^\s*#{_action}\s*/i)

                  pageObject=vh[condition].match(/^\s*#{_action}\s*\((.*)\)\s*$/i)[1]


                  puts __FILE__ + (__LINE__).to_s + " matched on #{_action}, pg:#{pg}, #{pageObject}"

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

              puts __FILE__ + (__LINE__).to_s + " ADDING  #{k} : #{_rc}"
              #           puts "====> #{k} : #{_rc.class} : #{_rc.length}"


              result.flatten!
            end


          end
        end

      end


      result=nil if result.empty?
      puts __FILE__ + (__LINE__).to_s + " result : #{result}"
      result
    end



  end



end
