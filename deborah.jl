
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
    do 
        Button A MoveF:
        Button B MoveF:
        Button C Turn L:
        Button D Turn L:
    done
=#


# Main 
function main()
    while true
        displayGrammar()
        input = String(strip(Base.prompt("Enter a sentence | Enter END to terminate Program"))) # asks the user for an input, waits for the input, strips the input from white space and then ensures that it is of string value
        try
            if validateInput(input)
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