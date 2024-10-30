# Function to generate PBASIC code after successful derivation
function generatePBASIC(userInput::String)
    # Define a dictionary for movement translations to PBASIC subroutine names
    movement_translation = Dict(
        "DRIVE" => "Forward",
        "BACK" => "Backward",
        "LEFT" => "TurnLeft",
        "RIGHT" => "TurnRight",
        "SPINL" => "SpinLeft",
        "SPINR" => "SpinRight"
    )

    # Start constructing the PBASIC code as a string
    pbasic_code = "{STAMP BS2p}\n"
    pbasic_code *= "{PBASIC 2.5}\n"
    pbasic_code *= "KEY VAR Byte\n"
    pbasic_code *= "Main:\n"
    pbasic_code *= "    DO\n"
    pbasic_code *= "        SERIN 3,2063,250,Timeout,[KEY]\n"
    

    # Loop through each key assignment in the user input
    assignments = split(userInput, ";")
    for assignment in assignments
        key_movement = strip(assignment)
        if isempty(key_movement)
            continue
        end
        
        # Split key assignment into key and movement
        parts = split(key_movement, "=")
        if length(parts) != 2
            println("Error in assignment format: '$key_movement'. Skipping this assignment.")
            continue
        end

        key = strip(parts[1])
        movement = strip(parts[2])

        # Map movement to PBASIC subroutine and format the conditional statement
        pbasic_movement = movement_translation[movement]
        pbasic_code *= "    IF KEY = '$key' OR KEY = '$(lowercase(key))' THEN GOSUB $(pbasic_movement)\n"
    end

    # Complete the PBASIC main loop and movement procedures
    pbasic_code *= """
    LOOP
  Timeout:
    GOSUB Motor_OFF
    GOTO Main

Forward:
  HIGH 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN

Backward:
  HIGH 12 : LOW 13 : HIGH 14 : LOW 15 : RETURN

TurnLeft:
  HIGH 13 : LOW 12 : LOW 15 : LOW 14 : RETURN

TurnRight:
  LOW 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN

SpinLeft:
  HIGH 13 : LOW 12 : LOW 15 : HIGH 14 : RETURN

SpinRight:
  LOW 13 : HIGH 12 : HIGH 15 : LOW 14 : RETURN

Motor_OFF:
  LOW 13 : LOW 12 : LOW 15 : LOW 14 : RETURN
"""

    # Display the generated PBASIC code on the screen
    println("\nGenerated PBASIC Code:\n")
    println(pbasic_code)

    # Save the generated PBASIC code to a file
    open("iZEBOT.BSP", "w") do file
        write(file, pbasic_code)
    end
    println("\nPBASIC code saved to iZEBOT.BSP")
end

