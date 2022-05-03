#Beskrivning: Funktionen läser in en textfil och delar upp innehållet till element i en lista, som separeras efter varje dubbel nyrad, elementen delas sedan upp i ännu en lista med två element efter ny rad
#Argument:    Textfil
#Return:      Returnerar en 2 dimensionell lista av storleken [x][2]
#Exemepel:    Förutsatt att textfilen följer den bestämda strukturen, se exempel nedan
#
#             2014-01-03
#             Hej på digahwd
#
#             2016-05-09
#             dear diary...
#
#             så returneras detta: 
#             [["2014-01-03", "Hej på digahwd"], ["2016-05-09", "dear diary..."]]
#By:          Frida Wallström och Vigor Turujlija Gamelius
#Date:        2022-05-03

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

def grab_password(file_name)
    file_content = File.read(file_name)
end 