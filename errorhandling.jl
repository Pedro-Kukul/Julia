# Function to validate Input, and check for Wake and Sleep
function validateInput(input::String)
    input = strip(input)  # Remove leading/trailing whitespace
    
    if !startswith(input, "wake")
        throw("Error: Program must start with 'wake'")
    elseif !endswith(input, "sleep")
        throw("Error: Program must end with 'sleep'")
    end
    
    # Remove 'wake' and 'sleep' from the input for further validation
    input = strip(replace(input, "wake", "", "sleep", ""))
    
    # Validate key assignments and movements
    validateKeyAssignments(input)
end

# Function to validate key assignments
function validateKeyAssignments(input::String)
    valid_keys = ["a", "b", "c", "d"]
    valid_movements = ["DRIVE", "BACK", "LEFT", "RIGHT", "SPINL", "SPINR"]
    
    # Split by semicolons to get each assignment
    assignments = split(input, ";")
    
    assigned_keys = Set()  # To track already assigned keys
    
    for assignment in assignments
        assignment = strip(assignment)
        
        # Skip empty assignments (e.g. trailing semicolons)
        if isempty(assignment)
            continue
        end
        
        # Check if the assignment is in the correct format: key x = MOVE
        if !startswith(assignment, "key")
            throw("Error: Each assignment must start with 'key'")
        end
        
        # Extract key and movement
        parts = split(replace(assignment, "key", ""), "=")
        if length(parts) != 2
            throw("Error: Invalid assignment format, expected 'key x = MOVE;'")
        end
        
        key = strip(parts[1])
        movement = strip(parts[2])
        
        # Validate key
        if !(key in valid_keys)
            throw("Error: Invalid key '$key'. Valid keys are: a, b, c, d.")
        elseif key in assigned_keys
            throw("Error: Key '$key' is assigned multiple times.")
        else
            push!(assigned_keys, key)  # Mark key as assigned
        end
        
        # Validate movement
        if !(movement in valid_movements)
            throw("Error: Invalid movement '$movement'. Valid movements are: DRIVE, BACK, LEFT, RIGHT, SPINL, SPINR.")
        end
    end
end

# Main function
function main()
    while true
        println("Enter a program (or 'END' to quit):")
        input = strip(readline())
        
        if input == "END"
            println("Exiting program.")
            break
        end
        
        try
            validateInput(input)
            println("Program is valid.")
        catch e
            println(e)  # Print the error message
        end
    end
end

# Calling the main function to start
main()
