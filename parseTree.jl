include("helpers.jl")

#function to print the top of the parse tree
function topPart()
    top = ["[program]","wake","[assignments]","sleep","[key-assign]", "[x]", "[y]"]
    println("                             $(top[1])")
    println("                       /          |        \\     ")
    println("                    $(top[2])   $(top[3])  $(top[4])")
    println("                             /        \\");
end 

#= 
Assumption that the function takes the string that has alrady been verified and adheres to the BNF grammar
Function call example : 
parseTree("wake key a = DRIVE; sleep)
parseTree("wake key a = DRIVE; key b = BACK; sleep)
parseTree("wake key a = DRIVE; key b = BACK; sleep; key  c   =   LEFT; )
parseTree("wake key a = DRIVE; key b = BACK;  key  c   =   LEFT;  key d   =   RIGHT  sleep")

=#
function parseTree(input::String)

    inputF = split(input)
    inputLength = length(inputF)
#index  =       1        2           3           4          5           6      7 
    top = ["[program]","wake","[assignments]","sleep","[key-assign]", "[x]", "[y]"]

    
    if inputLength == 6               # Tree for 1 key
        println("                    $(top[1])")
        println("             /           |        \\      ")
        println("           $(top[2])   $(top[3])  $(top[4])")
        println("                         |");
        println("                    $(top[5])")
        println("                        /    \\      ");   
        println("                  key $(top[6]) = $(top[7])")
        println("                       |     |")
        println("                       $(inputF[3])   $(chop(inputF[5]))")

    elseif inputLength == 10            # Tree for 2 keys
        
        topPart()
        println("                     $(top[5]) ; $(top[3])")
        println("                         /   \\           \\")
        println("                   key $(top[6]) = $(top[7])      $(top[5]) ")
        println("                        |     |          /   \\")
        println("                        $(inputF[3])  $(chop(inputF[5]))   key $(top[6]) = $(top[7])")
        println("                                        |     |")
        println("                                        $(inputF[7])    $(inputF[9])  ")

    elseif inputLength == 14            #Tree for 3 keys

        topPart()
        println("                     $(top[5]) ; $(top[3])")
        println("                        /   \\                /     \\")
        println("                  key $(top[6]) = $(top[7])      $(top[5]) ; $(top[3]) ")
        println("                       |     |           /   \\             \\")
        println("                       $(inputF[3])   $(chop(inputF[5]))   key $(top[6]) = $(top[7])      $(top[5])")  
        println("                                        |    |            /   \\") 
        println("                                        $(inputF[7])   $(chop(inputF[9]))    key $(top[6]) = $(top[7])  ")
        println("                                                         |     |")
        println("                                                         $(inputF[11])    $(chop(inputF[13])) ")    
    
    elseif inputLength == 18            #Tree for 4 keys 

        topPart()
        println("                    $(top[5])  ;  $(top[3])")
        println("                        /   \\               /     \\")
        println("                  key $(top[6]) = $(top[7])    $(top[5])  ;  $(top[3]) ")
        println("                       |     |           /   \\         /        \\")
        println("                       $(inputF[3])   $(chop(inputF[5]))   key $(top[6]) = $(top[7])  $(top[5]) ; $(top[3]) ")  
        println("                                        |     |         /   \\           \\") 
        println("                                        $(inputF[7])   $(chop(inputF[9]))  key $(top[6]) = $(top[7])      $(top[5])")
        println("                                                       |     |           /    \\")
        println("                                                       $(inputF[11])    $(chop(inputF[13]))   key $(top[6]) = $(top[7])")
        println("                                                                        |     |")       
        println("                                                                        $(inputF[15])    $(chop(inputF[17]))")   


    end 
end