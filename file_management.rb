def grab_diary(file_name)
    file_content = File.read(file_name)
    day_array = file_content.split("\n\n")
    day_array.map!{|day| day.lstrip.chomp}

    result = []
    day_array.each_with_index do |str, i|
        arr = str.split("\n")
        result[i] = [arr[0], arr[1..-1].join("\n")]
    end
    return result
end

def save_changes(day_array, file_name)
   
    content = ""
    day_array.each do |day|
        content += day[0] + "\n"
        content += day[1] + "\n\n"
    end 
    
    File.write(file_name, content)
end