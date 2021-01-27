# try to import rainbow for underlining text entries
begin
  $r_inst = require "rainbow"
rescue => LoadError
  $r_inst = false
  puts "rainbow not installed"
end

class String
  def underline
    # if rainbow is imported, return underlined text. otherwise, return the same string
    if $r_inst
      return Rainbow(self).underline
    else
      return self
    end
  end
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print(students)
  i = 0
  while i < students.length
    student = students[i]
    if student[:mkultra]
      mkultra_volunteer = "is a willing particapent"
    else
      mkultra_volunteer = "will not participate"
    end
    out = "#{i+1}. #{student[:name].underline} is a nember of the #{student[:cohort].to_s.underline} cohort. He is #{student[:tallness].underline} high, 
          does #{student[:hobby].underline} for fun, and #{mkultra_volunteer.underline} in this faculties MKULTRA program"
    puts out.center(out.length + 50)
    i += 1
  end
end

def print_footer(names)
  puts "Overall, we have #{names.count} great students"
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  # create an empty array
  students = []
  # get the first name
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    puts "Which cohort does #{name} belong to?"
    cohort = gets.chomp.capitalize
    if cohort.empty? then cohort = "November" end
    puts "What does #{name} like to do for fun?"
    hobby = gets.chomp
    puts "How tall is #{name}?"
    tallness = gets.chomp
    puts "Would #{name} like to volunteer as a subject in evil experiments?"
    mkultra = gets.chomp
    mkultra = true
    # add the student hash to the array
    students << {name: name, cohort: cohort.to_sym, hobby: hobby, tallness: tallness, mkultra: mkultra}
    puts "Now we have #{students.count} students"
    # get another name from the user
    name = gets.chomp
  end
  # return the array of students
  students
end

#nothing happens until we call the methods
students = input_students
print_header
print(students)
print_footer(students)
