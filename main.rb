require_relative('file_management.rb')
require 'date'

system("clear") || system("cls") 

day_array = grab_diary('dagbok.txt')
password = grab_password('password.txt')

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

# Beskrivning:  Funktion som går igenom en lista och letar efter ett visst element i listan.
#               Funktionen returnerar nil ifall elementet inte finns.
#               Funktionen tar ej hänsyn till datatyper.
# Argument 1:   Array - två dimensionell lista med tal, antingen integers, floats och/eller andra datatyper som kan rangordnas.
#               Listan skall vara sorterad baserat på första elementet av varje lista i listan.
# Argument 2:   Integer/Float - elementet som letas efter, funktionen kommer att matcha detta element mot första elementet i varje lista.
#               Dvs att funktionen kommer att matcha argument 2 mot argument_1[i][0], se exempel nedan
# Return:       Integer/nil - index där talet är eller nil om talet ej finns med
# Exempel:      
#               find_day([
#                            ["2014-01-03", "Hej på digahwd"],
#                            ["2016-05-09", "dear diary..."],
#                            ["2017-01-01", "programmeringsprojekt "],
#                            ["2020-04-08", "kartoffel"],
#                            ["2020-10-05", "123123123123"],
#                            ["2022-01-09", "eisfu"],
#                            ["2022-02-15", "riowi3w"]
#                        ], "2016-05-09") #=> 1
#               
#               find_day([
#                            ["2014-01-03", "Hej på digahwd"],
#                            ["2016-05-09", "dear diary..."],
#                            ["2017-01-01", "programmeringsprojekt "],
#                            ["2020-04-08", "kartoffel"],
#                            ["2020-10-05", "123123123123"],
#                            ["2022-01-09", "eisfu"],
#                            ["2022-02-15", "riowi3w"]
#                        ], "2016-05-08") #=> nil
#
#               find_day([
#                            ["2014-01-03", "Hej på digahwd"],
#                            ["2016-05-09", "dear diary..."],
#                            ["2017-01-01", "programmeringsprojekt "],
#                            ["2020-04-08", "kartoffel"],
#                            ["2020-10-05", "123123123123"],
#                            ["2022-01-09", "eisfu"],
#                            ["2022-02-15", "riowi3w"]
#                        ], 4) #=> nil
#
# By:           Vigor Turujlija Gamelius och Frida Wallstrom
# Date:         2022-05-03
def find_day(arr, target)
    left = 0
    right = arr.length - 1

    while left <= right do

        middle = ( (right - left) / 2 ) + left

        if arr[middle][0] == target
            return middle
        end

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
            puts ""
        end
        system("clear") || system("cls") 
        puts "Innehållet:"
        puts day_array[find_day(day_array, day)]
        puts ""
    elsif action == 1
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
            puts ""
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
        if !system("start #{day}", :err => File::NULL, :out => File::NULL) # Windows
            if !system("xdg-open '#{day}'", :err => File::NULL, :out => File::NULL) # Linux
                system("open '#{day}'", :err => File::NULL, :out => File::NULL) # Mac OSX, för er skull sir Widebrant ;)
            end
        end
        puts '' 
        loop do
            puts "Färdig? [j/n]"
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
        puts '' 
        File.delete(day) if File.exist?(day) # also remove the temporary file
    elsif action == 2
        system("clear") || system("cls")
        puts "datum?"
        day = gets().chomp 
        begin 
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
        system("clear") || system("cls")
        day_choice = ""
        loop do
            puts "Vilket datum vill du ta bort? Skriv 'visa' för att visa alla sparade datum."
            day_choice = gets().chomp
            if day_choice.downcase != "visa" then
                break;
            end
            system("clear") || system("cls")
            puts "Valbara datum:"
            print_alternatives(day_array)
            puts ""
        end

        day_array.delete_at(find_day(day_array, day_choice))
        save_changes(day_array, 'dagbok.txt')
        puts "borttaget!"
        puts ""
        return day_array
    end 
end

def encrypt_text(text)
    encrypted_text = []
    text.chars.each do |c|
        c = c.downcase
        if c.ord == 122 #z
            encrypted_text << (65).chr 
        elsif c.ord == 32 #mellanslag
            encrypted_text << (32).chr
        else
            encrypted_text << (c.ord + 1).chr 
        end 
    end
    encrypted_text = encrypted_text.join
    return encrypted_text
end 

def crypted_handle_day(action, day_array)
    if action == 0
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
            puts "" 
        end

        system("clear") || system("cls") 
        puts "Innehållet:"
        puts encrypt_text(day_array[find_day(day_array, day)][1])
        puts ""
    else 
        system("clear") || system("cls") 
        puts "Alternativet är inte tillgängligt, logga in!"
        puts ""
    end 
end 

#huvuddelen - loop som kör hela programmet 
puts "Logga in? [j/n]"
login_answer = gets().chomp.downcase
if login_answer == "j"
    login = 0 
    while login == 0
        puts "Lösenord:"
        entry = gets().chomp
        if entry == password
            login = 1
        else 
            puts "Fel lösenord"
            puts "Lösenord:"
            entry = gets().chomp
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
else 
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
        
        crypted_handle_day(action, day_array)
    end
end 
