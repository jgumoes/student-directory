
students = [{name: "Bob", cohort: "october", hobby: "hobbying along", 
                tallness: "about this big", mkultra: "definitely not"},
            {name: "Freddy the Murder Enthusiast", cohort: "June", hobby: "murdering", 
                tallness: "5 foot 7", mkultra: "nope"},
            {name: "Varg", cohort: "Ylir", hobby: "pillaging villages and monastaries", 
                tallness: "1 faomr", mkultra: "only if it pays well in mead and meat"}]

io = IO.popen("irb", "r+")
io.write "load 'ruby directory.rb'"
puts io.gets
students.each do |student|
    io.write student[:name]
    puts io.gets
    io.write student[:cohort]
    io.write student[:hobby]
    io.write student[:tallness]
    io.write student[:mkultra]
end

io.puts "\n"
io.close_write

# ruby directory.rb
# "Bob"
# "october"
# "hobbying along"
# "about this big"
# "definitely not"
# "Freddy the Murder Enthusiast"
# "June"
# "murdering"
# "5 foot 7"
# "nope"
# "Varg"
# "Ylir"
# "pillaging villages and monastaries"
# "1 faomr"
# "only if it pays well in mead and meat"