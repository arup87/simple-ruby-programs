require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phonenumber(phonenumber)
  number = phonenumber.scan(/\d/).join('')
  if number.length<10 || number.length>11
    number = "0000000000"
  elsif number.length==11
    if number[0]=='1'
      number[0]=''
    else
      number = "0000000000"
    end 
  end
  return number
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,personal_letter)
  Dir.mkdir("output") unless Dir.exists? "output"
  filename = "output/thanks_#{id}.html"
  File.open(filename,'w') do |file|
    file.puts personal_letter
  end 
end

puts "EventManager initialized."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phonenumber = clean_phonenumber(row[:homephone])
  puts "#{name} #{zipcode} #{phonenumber} | #{phonenumber.length}"
  personal_letter = erb_template.result(binding)  
  save_thank_you_letters(id,personal_letter)
end