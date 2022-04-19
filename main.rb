require_relative('file_management.rb')

def handle_day(day, action)

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

    puts "\n\nVälj en dag: "
    grab_diary("dagbok.txt").each do |day|
        puts day.split("\n", 2)[0] # Delar bara till två delar för att optimera, sedan skriver vi bara ut datumet
    end
    day_choice = gets().chomp

    handle_day(day_choice, action)
end
