require 'json'
require 'mechanize'
require 'date'

class Date
  def all_months_until to
    from = self
    from, to = to, from if from > to
    m = Date.new from.year, from.month
    result = []
    while m <= to
      result << m
      m >>= 1
    end

    result
  end
end

def days_in_month(year, month)
  Date.new(year, month, -1).day
end

require_relative 'forecast'
agent = Mechanize.new
sd = Date.parse(ARGV[0])
ed = Date.parse(ARGV[1])
file_output = []
sd.all_months_until(ed).each do |date|
  month = date.month
  year = date.year
  page = agent.get("http://www.wunderground.com/history/airport/LKCV/" + year.to_s + "/" + month.to_s + "/12/MonthlyCalendar.html?req_city=Havlickuv%20Brod&req_state=&req_statename=Czech%20Republic&reqdb.zip=00000&reqdb.magic=6&reqdb.wmo=11659")
  for day in 1..days_in_month(year, month)
    day_table = page.search("td.day")[day - 1]
    forecast = Forecast.new
    forecast.weather = day_table.search(".show-for-large-up").text.gsub("\n \s","")
    forecast.min_temp = day_table.search(".low")[0].text
    forecast.max_temp = day_table.search(".high")[0].text
    forecast.rain_amount = day_table.search(".wx-value").last.text.delete("\n \t")
    forecast.date = Date.new(year,month,day)
    puts forecast.to_json
    file_output << forecast
    puts
  end
end
File.write("output.txt", file_output.to_json)
puts "Saved to output.txt"