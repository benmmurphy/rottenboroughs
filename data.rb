#!/usr/bin/env ruby
require 'csv'
require 'json'

def load_employees
  employees = CSV.parse(File.read("employees.csv").force_encoding("iso-8859-1"))
  result = {}
  employees.each do |line|
    county = line[0]
    salary = line[1].gsub(",", "").to_i
    delta = line[2].to_f
    result[county] = {:salary => salary, :change => delta}
  end
  result
end

def lerp(color_start, color_end, min, max, value)
  range = max - min
 
  diff_r = color_end[0] - color_start[0]
  diff_g = color_end[1] - color_start[1]
  diff_b = color_end[2] - color_start[2]

  ratio = (value - min) / range.to_f
  [color_start[0] + diff_r * ratio, color_start[1] + diff_g * ratio, color_start[2] + diff_b * ratio]
end

counties = File.read("counties.txt").split("\n")
rich = CSV.parse(File.read("RICH2.csv").force_encoding("iso-8859-1"))

chief_map = {}
rich.each do |line|
  #puts line.inspect
  council = line[0]
  salary = line[4].gsub(",", "").to_i
  change = line[5].gsub("%", "").to_f
  if salary == 0
    next
  end
  chief_map[line[0]] = {:salary => salary, :change => change}
end

chief_map["Bedford"] = chief_map["Bedford Borough"]
chief_map["County Durham"] = chief_map["Durham"]
chief_map["Kingston upon Hull"] = chief_map["Kingston upon Hull, City of"]
chief_map["City of London"] = chief_map["Greater London Authority"]
data_json = {}

min_salary = 1.0/0.0
max_salary = 0

employee_data = load_employees
employee_data["City of London"] = employee_data["London"]

counties.each do |county|
  salary = chief_map[county]
  data_json[county] = {:ceo => salary}
  if salary.nil?
    #puts "missing: #{county}"
  else
    min_salary = [min_salary, salary[:salary]].min
    max_salary = [max_salary, salary[:salary]].max
  end

  edata = employee_data[county]
  if edata.nil?
    #puts "missing: #{county}"
  else 
    #puts "not missing: #{county}"
  end

  data_json[county][:employee] = edata
end


start_color = [0xcd, 0x00, 0x00]
end_color = [0x8c, 0xbf, 0x26]

counties.each do |county|
  data = data_json[county]
  if !data[:ceo].nil?
    salary = data[:ceo][:salary]
    color = lerp(end_color, start_color, min_salary, max_salary, salary)
    hexc = color.map{|x| x.to_i.to_s(16).rjust(2, "0")}.join
    data[:color] = "##{hexc}"
  end
end

puts "window.council_data="
puts data_json.to_json
