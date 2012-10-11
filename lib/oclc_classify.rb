module OCLC

  VERSION = '0.0.1'
  require 'nokogiri'
  require 'open-uri'

  BASE_URL = 'http://classify.oclc.org/classify2/Classify?'
  
  ARGUMENTS = [
    'stdnbr',
    'oclc',
    'isbn',
    'issn',
    'upc',
    'ident',
    'heading',
    'lccn',
    'lccn_pfx',
    'lccn_yr',
    'lccn_sno',
    'swid',
    'author',
    'title',
    'summary',
  ]

  ORDER_KEY = 'orderBy'
  MXREC_KEY = 'maxRecs'

  class Classify
  
    attr_reader :url

    ##
    # oclc = OCLC::Classify.new 'oclc', '610837844'
    # result = oclc.classify
    # p result.author
    # p result.title
    # r = result.recommendations 'ddc', :popular
    # s = result.recommendations 'ddc', :recent
    # t = result.recommendations 'ddc', :latest
    # p r
    # p s
    # p t
    # r.each {|k,v| puts k['nsfa'] }

    def initialize(input, value, summary = false, orderBy = nil, maxRecs = nil)
      raise "Invalid argument parameter: " + input unless ARGUMENTS.include? input
      @summary = summary ? '&summary=true' : '&summary=false'
      @query_string = input + '=' + value + @summary
      @orderBy = orderBy
      @maxRecs = maxRecs.to_s if maxRecs
      self
    end

    def orderBy(entry)
      @orderBy ||= entry
    end

    def maxRecs(number)
      @maxRecs ||= number.to_s
    end

    def classify
      @url = construct_query
      return OCLC::Classify::Response.new(@url)
    end

    private

    def construct_query
      query = BASE_URL + @query_string
      query = query + '&' + ORDER_KEY + '=' + @orderBy if @orderBy
      query = query + '&' + MXREC_KEY + '=' + @maxRecs if @maxRecs
      return query
    end

    class Response

      attr_reader :response, :code, :author, :title

      XPATH = {
        :code            => '//response/@code',
        :author          => '//work/@author',
        :title           => '//work/@title',
        :recommendations => '//recommendations',
      }

      KEYS = {
        :popular => 'mostpopular',
        :recent  => 'mostrecent',
        :latest  => 'latestedition',
      }

      def initialize(url)
        @response = Nokogiri::HTML(open(url))
        @code     = @response.xpath(XPATH[:code]).to_s
        @author   = @response.xpath(XPATH[:author]).to_s
        @title    = @response.xpath(XPATH[:title]).to_s
      end

      def recommendations(scheme, key)
        raise "Invalid scheme: must be 'ddc' or 'lcc'" unless scheme =~ /(dd|lc)c/
        raise "Invalid key: " + key.to_s unless KEYS.keys.include? key 
        path = '/' + scheme + '/' + KEYS[key]
        if @code == '0' or @code == '2'
          results = OCLC::Classify::Recommendations.new(@response.xpath(XPATH[:recommendations] + path))
          results.process
          return results.recommendations
        else
          return []
        end
      end
    
    end

    class Recommendations
      
      attr_reader :recommendations

      def initialize(xml)
        @xml = xml
        @recommendations = []
      end

      def process
        @xml.each do |r|
          box = {}
          k = r.attributes.keys
          r.attribute_nodes.each_with_index do |a, idx|
            box[k[idx]] = a.value
          end
          @recommendations << box
        end
      end

    end
    
  end
end