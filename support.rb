class Numeric
  def days
    self * (60*60*24)
  end
  alias :day :days
  
  def weeks
    self * 7.days
  end
  alias :week :weeks
end

class Time
  def end_of_week
    days_to_sunday = wday!=0 ? 7-wday : 0
    (self + days_to_sunday.days)
  end

  def next_week
    self + 7.days
  end

  def yesterday
    self - 1.day
  end

  def tomorrow
    self + 1.day
  end
end
