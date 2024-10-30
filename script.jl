
# Function to validate Input, and check for Termination Command
function validateInput(input::String)
    # accepts a string, the ::String can be removed if its causing issues which it should not

    terminationCommand = "END" # Termination Command

    if (isempty(input))
        throw("Expected String; Recieved null") # If input is empty throw error 
    elseif (uppercase(input) == terminationCommand && input != terminationCommand)
        throw("Did you mean $terminationCommand?") # If input is not quit in FULL caps but quit then throw error
    end

    return input == terminationCommand # If true returns true
end

# Function to read and write a Pbasic program with the .bas extension
function readAndWritePBasicProgram(pbasic_code::String)
    file = "IZEBOT.BSP"

    open(file, "w") do foo  # Open the file specified in write mode
        write(foo, pbasic_code) # Write the PBASIC code to the file
    end

    open(file, "r") do foo  # Open the file in read mode
        contents = read(foo, String)    # Read the contents as a string
        println(contents)   #Print the file per line
    end

    # run(`code $file`)   # Opens the file with vscode
end

#=  Grammer 
    <program>   = do <stmt_list> done
    <stmt_list> = <stmt> | <stmt> : <stmt_list>
    <stmt>      = Button <var> <direction>
    <var>       = A | B | C | D
    <direction> = MoveF | MoveB | TurnL | TurnR | SpinL | SpinR
=#
# Displays Grammar complicated af cause yes
function displayGrammar()
    # Define the grammar as an array of arrays for padding purposes and i hate myself
    grammar_rules = [
        ["<program>", "→", "", "do <stmt_list> done"],
        ["<stmt_list>", "→", "", "<stmt>"],
        ["", "→", "|", "<stmt> : <stmt_list>"],
        ["<stmt>", "→", "", "Button <x> <direction>"],
        ["<x>", "→", "", "A | B | C | D"],
        ["<direction>", "→", "", "MoveF | MoveB | TurnL | TurnR | SpinL | SpinR"]
    ]
    padding_lengths = [15, 5, 2, 15]  # Padding array that has same index as item to be padded

    # Print each rule with appropriate padding
    println("\nGrammar")
    for rule in grammar_rules
        println(join([rpad(item, padding_lengths[i]) for (i, item) in enumerate(rule)], ""))
    end
end

#= Example
    do         Button A MoveF:        Button B MoveF:        Button C TurnL:        Button D TurnL:    done
    wake key a = DRIVE; key b = SPINL; sleep
=#
#=  Derivation
    do <stmt_list> done
    do <stmt> : <stmt_list> done
    do Button <x> <y> : <stmt_list> done
    do Button A <y> : <stmt_list> done
    do Button A MoveF : <stmt_list> done
    do Button A MoveF : <stmt> : <stmt_list> done
    do Button A MoveF : Button <x> <y> : <stmt_list> done
    do Button A MoveF : Button B <y> : <stmt_list> done
    do Button A MoveF : Button B MoveF : <stmt_list> done
    do Button A MoveF : Button B MoveF : <stmt> : <stmt_list> done
    do Button A MoveF : Button B MoveF : Button <x> <y> : <stmt_list> done
    do Button A MoveF : Button B MoveF : Button C <y> : <stmt_list> done
    do Button A MoveF : Button B MoveF : Button C TurnL : <stmt_list> done
    do Button A MoveF : Button B MoveF : Button C TurnL : <stmt> done
    do Button A MoveF : Button B MoveF : Button C TurnL : Button <x> <y> done
    do Button A MoveF : Button B MoveF : Button C TurnL : Button D <y> done
    do Button A MoveF : Button B MoveF : Button C TurnL : Button D TurnL done

=#



function leftMostDerivation(input::String)
    r_do = r"\bdo\b"
    r_done = r"\bdone\b"

    # Todo: Fix this output mess
    if !(occursin(r_do, input) || occursin(r_done, input))
        throw("'do' and 'done' must be included in the sentence")
    elseif (count(r_do, input) > 1)
        throw("Only one 'do' should be included")
    elseif (count(r_done, input) > 1)
        throw("Only one 'done' should be included")
    elseif (!startswith(input, r_do))
        throw("Sentence must start with 'do'")
    elseif (!endswith(input, r_done))
        throw("Sentence must end with 'done'")
    end

    # Declare a array that splits the input based on whitespace
    tokens = split(input)
    if length(tokens) > 2  # It has to be more than two since do and done have been checked already
        tokens = tokens[2:end-1] # remove the first and last elements of tokens array which is do and done
    else
        throw(ArgumentError("Enter instructions!")) #throw error if no ienstsructoisn
    end
    tokens = join(tokens, " ") # join tokens again by whitespace
    println(tokens) # send to process stmt lists
end
# Main 
function main()
    while true
        displayGrammar()
        print("Enter a sentence: Enter 'END' to terminate the program...")
        input = String(strip(readline())) # needs to redeclrare string after stripping for whitespace | al of it could have been done with: String(strip(Base.prompt("Enter a sentence | 'END' to terminate the program))) but idk if BAse counts as an external library

        try
            if !validateInput(input)
                leftMostDerivation(input)
            else
                println("Terminating Program...")
                break
            end
        catch e
            println("Error $e")
        end
    end
end

#calling main
main()