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
    result[county] = {:salary => salary, :delta => delta}
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
rich = CSV.parse(File.read("RICH.csv"))

chief_map = {}
rich.each do |line|
  chief_map[line[0]] = line[1].gsub(",", "").to_i
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
  data_json[county] = {:chief_executive_salary => salary}
  if salary.nil?
    #puts "missing: #{county}"
  else
    min_salary = [min_salary, salary].min
    max_salary = [max_salary, salary].max
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
  if !data[:chief_executive_salary].nil?
    color = lerp(end_color, start_color, min_salary, max_salary, data[:chief_executive_salary])
    hexc = color.map{|x| x.to_i.to_s(16).rjust(2, "0")}.join
    data[:color] = "##{hexc}"
  end
end

puts "window.council_data="
puts data_json.to_json
