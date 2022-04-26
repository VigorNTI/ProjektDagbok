require_relative('file_management.rb')
require 'date'

system("clear") || system("cls") 

day_array = grab_diary('dagbok.txt')

def print_alternatives(day_array)
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

def find_day(arr, target)
    left    = 0
    right   = arr.length - 1

    while left <= right do
        # start by finding the middle element between left and right
        middle = ( (right - left) / 2 ) + left

        # check if we find target
        if arr[middle][0] == target
            return middle
        end

        # change working area
        if arr[middle][0] < target
            left = middle + 1
        else
            right = middle - 1
        end
    end
    return nil
end


def day_unique(day_array, day_choice)
    day_array.each do |unique|
        if unique[0].chomp == day_choice
            return false
        end 
    end 
    return true 
end

def handle_day(action, day_array)
    if action == 0
        system("clear") || system("cls")
        day = ""
        loop do
            puts "Vilket datum vill du öppna? Skriv 'visa' för att visa alla sparade datum."
            day = gets().chomp
            if day.downcase != "visa" then
                break;
            end
            system("clear") || system("cls")
            puts "Valbara datum:"
            print_alternatives(day_array)
            puts "" # blank line
        end
        system("clear") || system("cls") 
        puts "Innehållet:"
        puts day_array[find_day(day_array, day)]
        puts ""
    elsif action == 1
        #ska kunna skrolla, skriva in var som helst - text editor, offset 
        system("clear") || system("cls")
        day = ""
        loop do
            puts "Vilket datum vill du redigera? Skriv 'visa' för att visa alla sparade datum."
            day = gets().chomp
            if day.downcase != "visa" then
                break;
            end
            system("clear") || system("cls")
            puts "Valbara datum:"
            print_alternatives(day_array)
            puts "" # blank line
        end

        # Validation and parsing
        begin  # "try" block
            day = Date.strptime(day, '%Y-%m-%d').strftime('%Y-%m-%d')
        rescue # optionally: `rescue Exception => ex`
            puts 'Vänligen tänk över din formattering och testa igen: yyyy-mm-dd'
            puts '' # blank line
            return
        end 

        # Create file with contents from day #{day}
        day_idx = find_day(day_array, day)
        if day_idx == nil
            system("clear") || system("cls")
            puts "Datum '#{day}' finns ej, vänligen försök igen"
            puts '' # blank space
            return
        end
        contents = day_array[day_idx][1]
        File.write(day, contents)

        # Inform the user
        puts "Din textredigerare kommer att öppna vald dag, spara och stäng dokumentet för att fortsätta"

        # Start the text editor and promt to continue
        if !system("cmd /c 'start #{day}'", :err => File::NULL, :out => File::NULL) # Windows
            if !system("xdg-open '#{day}'", :err => File::NULL, :out => File::NULL) # Linux
                system("open '#{day}'", :err => File::NULL, :out => File::NULL) # Mac OSX, för er skull sir Widebrant ;)
            end
        end
        puts '' # blank line
        loop do
            puts "Färdig? [J/n]"
            if gets().chomp.downcase == 'j'
                break
            end
        end

        # Get the new content and save it to the main file
        new_contents = File.read(day)
        day_array[day_idx][1] = new_contents
        save_changes(day_array, "dagbok.txt")
        system("clear") || system("cls")
        puts "Filen är nu sparad!"
        puts '' # blank space
        File.delete(day) if File.exist?(day) # also remove the temporary file
    elsif action == 2
        puts "datum?"
        day = gets().chomp 
        begin  # "try" block
            date = Date.strptime(day, '%Y-%m-%d')
            day = date.strftime('%Y-%m-%d')
            if day_unique(day_array, day)
                system("clear") || system("cls") 
                puts "innehåll?"
                content = gets().chomp
                entry = [day] + [content]
                day_array << entry
                day_array = sort_days(day_array)
                save_changes(day_array, 'dagbok.txt')
                system("clear") || system("cls") 
                puts "tillagt!"
                puts ""
            end 
        rescue StandardError => e 
            puts 'I am rescued'
            puts e.inspect
        end 
        return day_array
    elsif action == 3 
        print_alternatives(day_array)
        day_choice = gets().chomp
        system("clear") || system("cls") 
        if find_day(day_array, day_choice) == nil 
            puts "datumet finns ej"
        else 
            day_array.delete_at(find_day(day_array, day_choice))
            save_changes(day_array, 'dagbok.txt')
            puts "borttaget!"
            puts ""
            return day_array
        end 
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

