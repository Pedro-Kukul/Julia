# Global Vars
global currentDerivation = String[]
global removedItems = String[]
global keyAssignmentCount = nothing
global currentSemicolonCount = 0
global assignedKeys = Set{String}()
global assignments = String[]

const global validX = Set(["a", "b", "c", "d"])
const global validY = Set(["DRIVE", "BACK", "LEFT", "RIGHT", "SPINL", "SPINR"])
const global terminationCommand = "ABORT"

function resetGlobals()
    global currentDerivation = String[]
    global removedItems = String[]
    global keyAssignmentCount = 0
    global currentSemicolonCount = 0
    global derivationSteps = String[]
    global assignedKeys = Set{String}()
    global assignments = String[]
end

function validateUserInput(userInput::String)
    userInput = strip(userInput)
    wakeCount = count("wake", userInput)
    sleepCount = count("sleep", userInput)

    if isempty(userInput) # if empty
        throw("Expected Instructions; Received null")
    elseif uppercase(userInput) == terminationCommand && userInput != terminationCommand # if almost 'ABORT'
        throw("Did you mean $terminationCommand?")
    elseif userInput == terminationCommand # if 'ABORT'
        println(colorize("Terminating Program...:", :white, :red))
        exit()
    elseif wakeCount < 1 # if no 'wake' 
        throw("'wake' must be included.")
    elseif sleepCount < 1 # if no 'sleep'
        throw("'sleep' must be included.")
    elseif wakeCount > 1 || sleepCount > 1 # if too many 'wake' or sleep'
        throw("The input should have exactly one 'wake' and one 'sleep'.")
    elseif !startswith(userInput, "wake") # if not start with 'wake'
        throw("The input string should start with 'wake'.")
    elseif !endswith(userInput, "sleep") # if not end with 'sleep'
        throw("The input string should end with 'sleep'.")
    end

    return true
end

# Pretty Colors
function colorize(char::String, fgColor::Symbol, bgColor::Symbol)
    foregroundColors = (
        black="\u001b[30m", red="\u001b[31m", green="\u001b[32m", yellow="\u001b[33m", blue="\u001b[34m",
        magenta="\u001b[35m", cyan="\u001b[36m", white="\u001b[37m", bBlack="\u001b[90m", bRed="\u001b[91m",
        bGreen="\u001b[92m", bYellow="\u001b[93m", bBlue="\u001b[94m", bMagenta="\u001b[95m", bCyan="\u001b[96m",
        bWhite="\u001b[97m", reset="\u001b[0m", none=""
    )

    backgroundColors = (
        black="\u001b[40m", red="\u001b[41m", green="\u001b[42m", yellow="\u001b[43m", blue="\u001b[44m",
        magenta="\u001b[45m", cyan="\u001b[46m", white="\u001b[47m", bBlack="\u001b[100m", bRed="\u001b[101m",
        bGreen="\u001b[102m", bYellow="\u001b[103m", bBlue="\u001b[104m", bMagenta="\u001b[105m", bCyan="\u001b[106m",
        bWhite="\u001b[107m", reset="\u001b[0m", none=""
    )

    # Return the combined color codes and the text using `string` for faster concatenation
    return string(backgroundColors[bgColor], foregroundColors[fgColor], char, foregroundColors[:reset], backgroundColors[:reset])
end

# Helper function for formatting grammar rules with padding
function format_rule(rule, paddingLengths)
    return join([rpad(item, paddingLengths[i]) for (i, item) in enumerate(rule)], "")
end

# Helper Function to Display Grammar
function displayGrammar()
    # Define the grammar rules as an array of arrays
    grammar_rules = [
        ["[program]", "→", "", "wake [assignments] sleep"],
        ["[assignments]", "→", "", "[key-assign];"],
        ["", "→", "|", "[key-assign]; [assignments]"],
        ["[key-assign]", "→", "", "key [x] = [y]"],
        ["[x]", "→", "", "a | b | c | d"],
        ["[y]", "→", "", "DRIVE | BACK | LEFT | RIGHT | SPINL | SPINR"]
    ]
    paddingLengths = [15, 5, 2, 30]  # Adjusted padding for better alignment
    terminalWidth = 150 # terminal width
    println()
    border = colorize("#", :magenta, :yellow)^terminalWidth #

    # Print the header
    println(border)
    println(colorize("Grammar Rules:", :blue, :green))
    println(border)

    # Print each grammar rule with padding
    for rule in grammar_rules
        println(colorize(format_rule(rule, paddingLengths), :blue, :green))
    end

    println(border)
end

# Initialize the global variables
global derivationSteps = String[]
global derivationCounter = 0

function updateDerivationSteps!(target::String, replacement::String)
    # Declare global variables
    global derivationSteps
    global derivationCounter

    # Define padding lengths for each section: [program], arrow, and derivation step
    paddingLengths = [15, 5, 30]

    # If derivationSteps is empty, initialize it with the target and discard replacement
    if isempty(derivationSteps)
        push!(derivationSteps, target)
        println(rpad("[program]", paddingLengths[1]), rpad("➝", paddingLengths[2]), derivationSteps[end])
        derivationCounter = 1
        return
    end

    # Retrieve the last step and find the leftmost occurrence of the target
    lastStep = derivationSteps[end]
    lastIndex = findfirst(occursin(target), split(lastStep, ""))

    # Replace only if the target is found
    if lastIndex !== nothing
        derivationCounter += 1
        newStep = replace(lastStep, target => replacement)
        push!(derivationSteps, newStep)

        # Print formatted output using padding lengths from the array
        println(rpad(string(derivationCounter), paddingLengths[1]),
            rpad("➝", paddingLengths[2]),
            rpad(derivationSteps[end], paddingLengths[3]))
    else
        throw("Derivation error: target not found")
    end
end

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


function generatePBASIC()
    global assignments

    # Define a dictionary for movement translations
    movement_translation = Dict(
        "DRIVE" => "FORWARD",
        "BACK" => "REVERSE",
        "LEFT" => "TURN_LEFT",
        "RIGHT" => "TURN_RIGHT",
        "SPINL" => "SPIN_LEFT",
        "SPINR" => "SPIN_RIGHT"
    )

    # Generate PBASIC code as a string
    pbasic_code = "PBASIC PROGRAM FOR IZEBOT\n"
    pbasic_code *= "----------------------------\n"
    for assignment in assignments
        # Ensure format "key [x] = [y]"
        parts = split(assignment, " ")
        if length(parts) < 4 || parts[3] != "="
            println("Error in assignment format: '$assignment'. Skipping this assignment.")
            continue
        end

        key = strip(parts[1])
        movement = strip(parts[4])

        # Translate movement to PBASIC instruction, handling missing movements
        pbasic_movement = get(movement_translation, movement, "UNKNOWN")
        pbasic_code *= "IF KeyPress = $key THEN $pbasic_movement\n"
    end
    pbasic_code *= "END\n"

    # Display generated code onscreen
    println("\nGenerated PBASIC Code:\n")
    println(pbasic_code)

    # Save generated code to a file
    open("IZEBOT.BSP", "w") do file
        write(file, pbasic_code)
    end
    println("\nPBASIC code saved to IZEBOT.BSP")

    # Prompt user to continue
    println("Press Enter to continue...")
    readline()
end