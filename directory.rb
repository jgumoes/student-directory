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

@students = []

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print_cohort()
  cohorts = @students.map { |s| s[:cohort] }
  cohorts.each do |cohort|
    puts "Students in the #{cohort.to_s.underline} cohort:"
    i = 0
    @students.each do |student|
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
end

def print_footer()
  puts "Overall, we have #{@students.count} great students"
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
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
    @students << {name: name, cohort: cohort.to_sym, hobby: hobby, tallness: tallness, mkultra: mkultra}
    s = ""
    if @students.count != 1 then s = "s" end
    puts "Now we have #{@students.count} student#{s}"
    # get another name from the user
    name = gets.trim
  end
  # return the array of students
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the students to students.csv"
  puts "4. Load students from students.csv"
  puts "5. Add the defualt students"
  puts "9. Exit"
end

def add_default_students
  # default list of students, to make testing some stuff less painfull
  default_students = [{name: "Bob", cohort: :October, hobby: "hobbying along", 
    tallness: "about this big", mkultra: "definitely not"},
  {name: "Freddy the Murder Enthusiast", cohort: :June, hobby: "murdering", 
    tallness: "5 foot 7", mkultra: "nope"},
  {name: "Olaf", cohort: :Ylir, hobby: "pillaging villages and monastaries", 
    tallness: "1 faomr", mkultra: "only if it pays well in mead and meat"},
  {name: "Fidget Man", cohort: :November, hobby: "being uncomfortable", 
    tallness: "man sized", mkultra: "strong no"},
  {name: "Fidget Boy", cohort: :November, hobby: "whatever Fidget Man is doing", 
    tallness: "boy sized", mkultra: "same as fidget man"},
  {name: "Varg", cohort: :Ylir, hobby: "making bad music and terrible RPGs", 
    tallness: "viking", mkultra: "it conflicts with his neo-pagan beliefs"}]
  
  default_students.each do |s|
    if !@students.include?(s)
      @students << s
    end
  end
  puts "Added the default students"
end

def process(selection)
  puts "\n++++++++++++++++\n\n"
  case selection
    when "1"
      input_students
    when "2"
      print_cohort()
    when "3"
      save_students()
    when "4"
      load_students()
    when "5"
      add_default_students()
    when "9"
      exit
    else
      puts "I don't think that was one of the options..."
  end
  puts "\n++++++++++++++++\n\n"
end

def show_students
  print_header()
  print_cohort()
  print_footer()
end

def load_students
  file = File.open("students.csv", "r")
  keys = file.readline.chomp.split(",").map { |k| k.to_sym }
  i_cohort = keys.index(:cohort)
  file.readlines.each do |line|
    line = line.chomp.split(",")
    line[i_cohort] = line[i_cohort].to_sym
    h = {}
    keys.each_with_index { |k, i| h[k] = line[i]}
    @students << h
  end
  file.close
  puts "Loaded students from students.csv"
end


def save_students
  if @students.length == 0
    puts "Their aren't any students to save"
  else
    # open the students file for writing
    file = File.open("students.csv", "w")
    # save keys to first line of file. this makes it easier to scale up what
    # data is stored for each student
    file.puts @students[0].keys.map { |k| k.to_s }.join(",")
    @students.each do |student|
      student_data = student.values # this is safe because hashes keep their values in the same order as inserted
      csv_line = student_data.join(",")
      file.puts csv_line
    end
    file.close
    puts "Saved the students"
  end
end

def interactive_menu
  loop do
    # show the menu options
    print_menu()
    process(gets.chomp.delete "a-zA-Z ")
  end
end

interactive_menu
