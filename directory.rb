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

  def trim
    # identical to chomp()
    return self.delete("\n\r")
  end
end

# default list of students, to make testing some stuff less painfull
$default_students = [{name: "Bob", cohort: "october", hobby: "hobbying along", 
  tallness: "about this big", mkultra: "definitely not"},
{name: "Freddy the Murder Enthusiast", cohort: "June", hobby: "murdering", 
  tallness: "5 foot 7", mkultra: "nope"},
{name: "Olaf", cohort: "Ylir", hobby: "pillaging villages and monastaries", 
  tallness: "1 faomr", mkultra: "only if it pays well in mead and meat"},
  {name: "Fidget Man", cohort: "", hobby: "being uncomfortable", 
    tallness: "man sized", mkultra: "strong no"},
    {name: "Fidget Boy", cohort: "", hobby: "whatever Fidget Man is doing", 
      tallness: "boy sized", mkultra: "same as fidget man"},
      {name: "Varg", cohort: "Ylir", hobby: "making bad music and terrible RPGs", 
        tallness: "viking", mkultra: "it conflicts with his neo-pagan beliefs"}]

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print(students)
  # prints each student in the order they were entered
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
  print_footer(students)
end

def print_cohort(students)
  cohorts = students.map { |s| s[:cohort] }
  cohorts.each do |cohort|
    puts "Students in the #{cohort.to_s.underline} cohort:"
    i = 0
    students.each do |student|
      if student[:cohort] == cohort
        if student[:mkultra]
          mkultra_volunteer = "is a willing particapent"
        else
          mkultra_volunteer = "will not participate"
        end
        out = "#{i+1}. #{student[:name].underline} is #{student[:tallness].underline} tall, "
        out += "does #{student[:hobby].underline} for fun, and #{mkultra_volunteer.underline} in this faculties MKULTRA program\n"
        puts out
        i += 1
      end
    end
    puts "\n"
  end
  print_footer(students)
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
  name = gets.trim
  # while the name is not empty, repeat this code
  while !name.empty? do
    puts "Which cohort does #{name} belong to?"
    cohort = gets.trim.capitalize
    if cohort.empty? then cohort = "November" end
    puts "What does #{name} like to do for fun?"
    hobby = gets.trim
    puts "How tall is #{name}?"
    tallness = gets.trim
    puts "Would #{name} like to volunteer as a subject in evil experiments?"
    mkultra = gets.trim
    mkultra = true
    # add the student hash to the array
    students << {name: name, cohort: cohort.to_sym, hobby: hobby, tallness: tallness, mkultra: mkultra}
    s = ""
    if students.count != 1 then s = "s" end
    puts "Now we have #{students.count} student#{s}"
    # get another name from the user
    name = gets.trim
  end
  # return the array of students
  students
end

def interactive_menu
  students = []
  loop do
    # show the menu options
    puts "1. Input the students"
    puts "2. Show the students"
    puts "5. Show the defualt students"
    puts "9. Exit"
    selection = gets.chomp.delete "a-zA-Z "
    puts "\n++++++++++++++++\n\n"
    case selection
    when "1"
      students = input_students
    when "2"
      print_header
      print_cohort(students)
    when "5"
      print_cohort($default_students)
    when "9"
      exit
    else
      puts "I don't think that was one of the options..."
    end
    puts "\n++++++++++++++++\n\n"
  end
end

interactive_menu

# #nothing happens until we call the methods
# students = input_students
# #print(students)
# if students.size > 0
#   print_header
#   print_cohort(students)
# end
