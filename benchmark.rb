#coding: utf-8
require './date_parser'
require 'benchmark'

messages = [
  "20 августа в Москве пройдет конференция по ruby",
  "10.08.2010 в Санкт-Петербурге начнется прокат самолетов",
  "в сентябре в Санкт-Петербурге пройдет семинар слонов",
  "с 10.08.2010 по 25.08.2010 в Санкт-Петербурге пройдет семинар слонов",
  "с 20 августа по 25 августа в Санкт-Петербурге пройдет семинар слонов",
  "пойду в кино в эти выходные",
  "пойду в кафе на следующих выходных",
].shuffle

parser = DateParser::Parser.new

n = (ARGV.shift || 1000).to_i

Benchmark.bm do |x|
  x.report("parse one message, object exist") do
    n.times { parser.parse(messages.first) } 
  end
end
