

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