require_relative 'jsonable'
class Forecast
  include Jsonable
  def initialize
  end
  def weather
    @weather
  end
  def min_temp
    @min_temp
  end
  def max_temp
    @max_temp
  end
  def rain_amount
    @rain_amount
  end
  def date
    @date
  end

  def min_temp=(new_temp)
    @temperature_min = new_temp
  end

  def max_temp=(new_temp)
    @temperature_max = new_temp
  end

  def rain_amount=(new_amount)
    @rain_amount = new_amount
  end

  def weather=(new_weather)
    @weather_label = new_weather
  end

  def date=(new_date)
    @date = new_date
  end
end