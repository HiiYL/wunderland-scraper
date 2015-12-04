require 'json'
require 'mechanize'
require_relative 'forecast'
agent = Mechanize.new
file_output = []
ARGV.each do |arg|
  date = arg
  date_array = date.split("/")
  day = date_array[0]
  month = date_array[1]
  year = date_array[2]
  page = agent.get("http://www.wunderground.com/history/airport/LKCV/" + year + "/" + month + "/12/MonthlyCalendar.html?req_city=Havlickuv%20Brod&req_state=&req_statename=Czech%20Republic&reqdb.zip=00000&reqdb.magic=6&reqdb.wmo=11659")
  day_table = page.search("td.day")[day.to_i - 1]
  forecast = Forecast.new
  forecast.weather = day_table.search(".show-for-large-up").text.gsub("\n \s","")
  forecast.min_temp = day_table.search(".low")[0].text
  forecast.max_temp = day_table.search(".high")[0].text
  forecast.rain_amount = day_table.search(".wx-value").last.text.delete("\n \t")
  forecast.date = date
  print forecast.to_json
  file_output << forecast.to_json << "\n"
  puts
end
File.write("output.txt", file_output)
puts "Saved to output.txt"