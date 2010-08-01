#coding: utf-8
require 'test/unit'
require './date_parser'

# Tests

class DateParserTest < Test::Unit::TestCase
  def setup
    @messages = {
      :date_word => "20 августа в Москве пройдет конференция по ruby",
      :date_doted => "10.08.2010 в Санкт-Петербурге начнется прокат самолетов",
      :month_name => "в сентябре в Санкт-Петербурге пройдет семинар слонов",
      :from_to_num => "с 10.08.2010 по 25.08.2010 в Санкт-Петербурге пройдет семинар слонов",
      :from_to_word => "с 20 августа по 25 августа в Санкт-Петербурге пройдет семинар слонов",
      :this_weekend => "пойду в кино в эти выходные",
      :next_weekend => "пойду в кафе на следующих выходных",
    }
    @parser = DateParser::Parser.new
  end

  def test_should_parse_day_num_and_month_name
    assert_equal @parser.parse(@messages[:date_word]), Date.parse('20 august')
  end

  def test_should_parse_day_num_and_month_num_and_year_num_doted
    assert_equal @parser.parse(@messages[:date_doted]), Date.parse('10.08.2010')
  end

  def test_should_parse_month_name
    assert_equal @parser.parse(@messages[:month_name]), Date.parse('1.09.2010')
  end

  def test_should_parse_this_weekend
    assert_equal @parser.parse(@messages[:this_weekend]), Time.now.end_of_week.yesterday.to_date
  end

  def test_should_parse_next_weekend
    assert_equal @parser.parse(@messages[:next_weekend]), Time.now.next_week.end_of_week.yesterday.to_date
  end
end
