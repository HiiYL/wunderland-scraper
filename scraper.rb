require 'json'
require 'mechanize'
class Forecast
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
    @min_temp = new_temp
  end

  def max_temp=(new_temp)
    @max_temp = new_temp
  end

  def rain_amount=(new_amount)
    @rain_amount = new_amount
  end

  def weather=(new_weather)
    @weather = new_weather
  end

  def date=(new_date)
    @date = new_date
  end
  def to_json
    {'weather' => @weather, 'min_temp' => @min_temp, 'max_temp'=> @max_temp,
     'rain_amount' => @rain_amount, 'date' => @date }.to_json
  end
end
agent = Mechanize.new
ARGV.each do |arg|
  date = arg
  date_array = date.split("/")
  day = date_array[0]
  month = date_array[1]
  year = date_array[2]
  page = agent.get("http://www.wunderground.com/history/airport/LKCV/" + year + "/" + month + "/12/MonthlyCalendar.html?req_city=Havlickuv%20Brod&req_state=&req_statename=Czech%20Republic&reqdb.zip=00000&reqdb.magic=6&reqdb.wmo=11659")
  day_table = page.search("td.day")[day.to_i]
  forecast = Forecast.new
  forecast.weather = day_table.search(".show-for-large-up").text.gsub("\n \s","")
  forecast.min_temp = day_table.search(".low")[0].text
  forecast.max_temp = day_table.search(".high")[0].text
  forecast.rain_amount = day_table.search(".wx-value").last.text.delete("\n \t")
  forecast.date = date
  print forecast.to_json
  puts
end