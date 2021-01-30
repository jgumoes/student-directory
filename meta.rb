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

puts "are you ready to get " + "meta?".underline
puts "we're going to open #{$0.underline} and print everything it contains"
puts "here we go...\n\n\n"
File.open($0, "r") do |file|
  puts file.readlines
end

puts "now wasn't that fun?\n\n\n".underline



