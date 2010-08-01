#coding: utf-8
require 'date'
require './support'

module DateParser

  class Parser
    def initialize(*formatters)
      @formatters = []
      (DEFAULT_FORMATTERS + formatters).each{|f| self << f }
    end

    def <<(formatter)
      raise ArgumentError if ! formatter.is_a? DateParser::Formatter
      @formatters << formatter
    end

    def parse(string)
      @formatters.each do |f|
        string = f.format(string)
        begin
          ::Date.parse(string.to_s)
        rescue ArgumentError 
          next
        else
          break
        end
      end
      
      if string.is_a? ::Date
        string
      else
        ::Date.parse(string.to_s) rescue nil
      end
    end
  end

  class Formatter

    def initialize(regexp, &block)
      if block.nil?
        raise ArgumentError.new("Block must be to given") 
      end
      
      regexp = "(#{regexp.join("|")})" if regexp.is_a? Array
      @regexp, @block = Regexp.new(regexp), block
    end

    def format(string)
      match_data = @regexp.match(string.to_s)

      if match_data
        @block.call(string.to_s, match_data) 
      else
        string.to_s
      end

    end
    
  end

  MONTHES = {
    :en     => Date::MONTHNAMES.dup.reject(&:nil?).map(&:downcase),
    :ru     => %w(января февраля марта апреля мая июня июля августа сентября октября ноября декабря),
    :ru_at  => %w(январе феврале марте апреле мае июне июле августе сентябре октябре ноябре декабре),
  }
  MONTHES[:ru2en] = Hash[ MONTHES[:ru].zip(MONTHES[:en]) ]
  MONTHES[:ru2en_at] = Hash[ MONTHES[:ru_at].zip(MONTHES[:en]) ]

  DEFAULT_FORMATTERS = [
    Formatter.new(MONTHES[:ru]) {|string, month| string.gsub! month.to_a.first, MONTHES[:ru2en][month.to_a.first]},
    Formatter.new(MONTHES[:ru_at]) {|string, month| string.gsub! month.to_a.first, MONTHES[:ru2en_at][month.to_a.first]},
    Formatter.new(/завтра/) {Time.now.tomorrow.to_date},
    Formatter.new(/следующие выходные|следующих выходных/){Time.now.next_week.end_of_week.yesterday.to_date},
    Formatter.new(/эти выходные|этих выходных|на выходных|в выходные/){Time.now.end_of_week.yesterday.to_date}
  ]
end








