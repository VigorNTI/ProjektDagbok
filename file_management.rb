def grab_diary(file_name)
    file_content = File.read(file_name)
    day_array = file_content.split("\n\n", -1)
    day_array.map!{|day| day.lstrip.chomp}
    return day_array
end