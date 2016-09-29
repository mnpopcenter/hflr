# This file is part of the Minnesota Population Center's hflr project.
# For copyright and licensing information, see the NOTICE and LICENSE files
# in this project's top-level directory, and also on-line at:
#   https://github.com/mnpopcenter/hflr

require File.dirname(__FILE__) + "/../lib/hflr"


# Read a file with only one record type (no record type markers)

# metadata for customer file
Column = Struct.new(:name,:start,:len)
columns = {:customer=>[
Column.new("name",1,25),
Column.new("zip",26,5),
Column.new("balance",31,5)]}
  
customer_file = FLRFile.new(File.new("customers.dat"), :customer, columns, 1, [:line_number])


# You can read through the file and access the fields with methods named after the columns:
customer_file.each do |record|
  puts "Customer #{customer_file.line_number.to_s} #{record.name} #{record.zip} "
end


# You can get the values by attribute name like a hash
def show(record)
  print record.members.map{|m| m.to_s + ": " + record[m].to_s}.join(", ") + "\n" 
  end
  
  
  # You can read the file in random order:
  customer_file.set_random
  record = customer_file.get_random_record(2)
puts "Record 2 randomly accessed:   #{record.name} #{record.zip} "
record = customer_file.get_random_record(0)
puts "Record 0 randomly accessed:   #{record.name} #{record.zip} "
record = customer_file.get_random_record(1)
puts "Record 1 randomly accessed:   #{record.name} #{record.zip} "

record = customer_file.get_random_record(11)
puts "Returns a nil if record is off the end of the file: #{record.to_s}"

  
  
  
# You can read through a file with more than one record type:
# metadata for customer_orders file
layouts = {:customer=>[
  Column.new("name",1,25),
  Column.new("zip",26,5),
  Column.new("balance",31,5)],  
:order=>[
  Column.new("order_num",1,8),
  Column.new("date",9,10),]}
  
  
customer_orders_file = FLRFile.new(
  File.new("customer_orders.dat"), 
  {"C"=>:customer,"O"=>:order},# Use these characters as record type markers 
  layouts, 
  0, # shift parsed string 0 columns to the left of the indicated start column 
  {:customer=>[:line_number,:record_type],:order=>[:line_number,:record_type]}) # Add these columns to the indicated record types post read
  
  
  customer_orders_file.each do |record|
    show record
  end
  

puts " ----- You can also use metadata in Ruby -----"
# Use Ruby metadata

layout = {:customer=>{
  :name=>1..25,
  :zip=>26..30,
  :balance=>31..35
  
}
}
customer_file = FLRFile.new(File.new("customers.dat"), :customer, layout, 1, [:line_number])


# You can read through the file and access the fields with methods named after the columns:
customer_file.each do |record|
  puts "Customer #{customer_file.line_number.to_s} #{record.name} #{record.zip} "
end

