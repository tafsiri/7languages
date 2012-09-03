biggest = {
  :name => "",
  :population => 0
}

lines_skipped = 0
File.foreach("data/allCountries.txt") do |line|
  row = line.split("\t")
  begin
    if row.length == 19
      pop = row[14].to_i
      if pop > biggest[:population]
        biggest[:population] = pop
        biggest[:name] = row[1]
      end
    else
      #something was wrong with that line in the input data
      lines_skipped += 1
    end
  rescue
    #something weird happened
    lines_skipped += 1
  end
end

puts lines_skipped
puts biggest.inspect