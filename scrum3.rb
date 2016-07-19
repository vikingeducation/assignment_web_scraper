
# Define a method called ordinal that takes an interger as an argument 
#and returns the ordinal version of the number as a string.

#    Examples:  ordinal(1)     => “1st”

#                        ordinal(2)     => “2nd”

#                        ordinal(11)    => “11th”

#                          ordinal(104)  => “104th”

#                          ordinal(-43)   => “-43rd”

# — Note: This problem is trickier than it appears. Be sure to test your edge cases.

def ordinal(num)
  return num.to_s +  'th' if num.abs.between?(11,13)
  #return num.to_s +  'nth' if num.abs.between?(14,19)  
  #1-9
  return num.to_s + 'st' if num.abs % 10 == 1
  return num.to_s + 'nd' if num.abs % 10 == 2
  return num.to_s + 'rd' if num.abs % 10 == 3
  return num.to_s +  'th' if num.abs % 10 <= 5 || num % 10 == 8
  
  return num.to_s +  'nth' if num.abs % 10 == 7 || num % 10  == 9 || num % 10 == 0
end

p ordinal(22)
p ordinal(104)
p ordinal(-43)
p ordinal(1)
p ordinal(2)
p ordinal(11)
p ordinal(19)