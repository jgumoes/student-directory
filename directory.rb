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
@keys = [:name,:cohort,:hobby,:tallness,:mkultra]

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def mkultra_volunteer student
  if student
    return "is a willing particapent"
  else
    return "will not participate"
  end
end

def print_cohort()
  if @students.empty?
    puts "No students have been entered yet"
  else
    cohorts = @students.map { |s| s[:cohort] }.uniq
    cohorts.each do |cohort|
      puts "Students in the #{cohort.to_s.underline} cohort:"
      i = 0
      @students.each do |student|
        if student[:cohort] == cohort
          out = "#{i+1}. #{student[:name].underline} is #{student[:tallness].underline} tall, "
          out += "does #{student[:hobby].underline} for fun, and #{mkultra_volunteer(student[:mkultra]).underline} in this faculties MKULTRA program\n"
          puts out
          i += 1
        end
      end
      puts "\n"
    end
  end
end

def print_footer()
  puts "Overall, we have #{@students.count} great students"
end

def gets
  return STDIN.gets
end

def key_questions key, name="Subject"
  case key
  when :name
    puts "Please enter the names of the students"
    puts "To finish, just hit return"
    return gets.trim
  when :cohort
    puts "Which cohort does #{name} belong to?"
    cohort = gets.trim.capitalize
    if cohort.empty?
      return :November
    else
      return cohort.to_sym
    end
  when :hobby
    puts "What does #{name} like to do for fun?"
    return gets.trim
  when :tallness
    puts "How tall is #{name}?"
    return gets.trim
  when :mkultra
    puts "Would #{name} like to volunteer as a subject in evil experiments?"
    mkultra = gets.trim
    return true
  end
end

def ask_for_input
  # cycles through the contents of @keys, and asks the user
  # for input for each key. assumes that the first key is
  # always :name
  name = key_questions(:name)
  while !name.empty? do
    values = [name]
    @keys[1..-1].each do |key|
      values.append(key_questions(key, name))
    end
    add_student_to_list(values)
    name = key_questions(:name)
  end
end 

def print_student_count
  s = ""
  if @students.count != 1 then s = "s" end
  puts "Now we have #{@students.count} student#{s}"
end

def add_student_to_list(values)
  # turns the list of values into a dictionary, then adds it to @students
  h = {}
  @keys.each_with_index { |k, i| h[k] = values[i]}
  if !@students.include?(h)
    @students << h
  else
    puts "Student Entry already exists"
  end
end

def input_students
  ask_for_input()
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
  default_students = [["Bob", :October, "hobbying along", "about this big", "definitely not"],
  ["Freddy the Murder Enthusiast", :June, "murdering", "5 foot 7", "nope"],
  ["Olaf", :Ylir, "pillaging villages and monastaries", "1 faomr", "only if it pays well in mead and meat"],
  ["Fidget Man", :November, "being uncomfortable", "man sized", "strong no"],
  ["Fidget Boy", :November, "whatever Fidget Man is doing", "boy sized", "same as fidget man"],
  ["Varg", :Ylir, "making bad music and terrible RPGs", "viking", "it conflicts with his neo-pagan beliefs"],
  ["Ted Cruz", :August, "people-watching couples in parks and making cryptography puzzles", "not very tall as his spine doesn't provide enough support", "yes"]
  ]
  
  default_students.each { |s| add_student_to_list(s) }
  puts "Added the default students"
  print_student_count()
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
      puts selection
  end
  puts "\n++++++++++++++++\n\n"
end

def show_students
  print_header()
  print_cohort()
  print_footer()
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  @keys = file.readline.chomp.split(",").map { |k| k.to_sym }
  i_cohort = @keys.index(:cohort)
  file.readlines.each do |line|
    values = line.chomp.split(",")
    values[i_cohort] = values[i_cohort].to_sym
    add_student_to_list(values)
  end
  file.close
  puts "Loaded students from #{filename}"
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

def try_load_students
  filename = ARGV.first # first argument from the command line
  return if filename.nil? # get out of the method if it isn't given
  if File.exists?(filename) # if it exists
    load_students(filename)
     puts "Loaded #{@students.count} from #{filename}"
  else # if it doesn't exist
    puts "Sorry, #{filename} doesn't exist."
    #exit # quit the program
  end
end

# run the code
try_load_students
interactive_menu
