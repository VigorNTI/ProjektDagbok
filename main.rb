require_relative('file_management.rb')

#lägg till raise 
day_array = grab_diary('dagbok.txt')

def print_alternatives(day_array)
    puts "\n\nVälj en dag: "
    day_array.each do |day|
        puts day[0]
    end
end 

def sort_days(day_array)
    day_array = day_array.dup
    output_list = []
    while day_array.length > 0
        i = 0
        smallest = 0
        while i < day_array.length 
            if day_array[smallest][0] > day_array[i][0]
                smallest = i
            end 
            i += 1
        end 
        output_list << day_array[smallest]
        day_array.delete_at(smallest)
    end 
    return output_list
end 

def find_day(day_array, day_choice)
    start = 0 
    finish = day_array.length
    while true 
        middle_i = (start + ((finish - start)/2.0)).floor
        if day_array[middle_i][0] == day_choice
            return middle_i 
        elsif start == finish
            if day_array[start][0] == day_choice
                return middle_i
            else 
                return nil
            end 
        elsif day_array[middle_i][0] < day_choice
            start = middle_i
        elsif day_array[middle_i][0] > day_choice
            finish = middle_i
        end 
    end 
end 

def handle_day(action, day_array)
    if action == 0
        print_alternatives(day_array)
        day_choice = gets().chomp
        puts day_array[find_day(day_array, day_choice)]
    elsif action == 1
        #ska kunna skrolla, skriva in var som helst - text editor, offset 
    elsif action == 2
        puts "datum?"
        day = gets().chomp 
        puts "innehåll?"
        content = gets().chomp
        entry = [day] + [content]
        day_array << entry
        day_array = sort_days(day_array)
        save_changes(day_array, 'dagbok.txt')
        puts "added!"
        return day_array
    elsif action == 3
        print_alternatives(day_array)
        day_choice = gets().chomp
        day_array.delete_at(find_day(day_array, day_choice))
        save_changes(day_array, 'dagbok.txt')
        return day_array
    end 
end

while true
    puts "Vad vill du göra med din dagbok?"
    puts "0 - Öppna"
    puts "1 - Redigera"
    puts "2 - Lägg till"
    puts "3 - Ta bort"
    puts "4 - Avsluta"
    action = gets().chomp.to_i

    if action == 4 then
        break
    end

    handle_day(action, day_array)
end

