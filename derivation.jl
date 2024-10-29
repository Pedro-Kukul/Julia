include("helpers.jl")

# Rename to something better
function processI(userInput::String)
    # Validation
    resetGlobals()
    validateUserInput(userInput)

    push!(currentDerivation, userInput) # push 
    tokens = split(userInput) #split string totally unnessecarry but what evs

    push!(removedItems, popfirst!(tokens))  # Removes and stores "wake"
    push!(removedItems, pop!(tokens))  # Removes and stores "sleep"

    if isempty(tokens) # if nothing in the array then error
        throw("Enter instructions!")
    end

    updateDerivationSteps!("wake [assignments] sleep", "")
    return processII(join(tokens, " "))
end

function processII(aids2::AbstractString)
    global keyAssignmentCount, currentSemicolonCount

    # Strip and find semicolon count
    aids2 = strip(aids2)
    currentSemicolonCount = count(isequal(';'), aids2)

    if currentSemicolonCount < 1
        throw("No valid instructions found. Instructions must end with a ';'.")
    end

    semicolon_index = findfirst(isequal(';'), aids2)

    aids3 = aids2[1:semicolon_index-1]  # Get the part before the semicolon
    aids2_remainder = aids2[semicolon_index+1:end]  # Get the remainder after the semicolon

    if keyAssignmentCount > 4
        throw("Maximum amount of buttons assigned. Cannot derive further: $aids2_remainder")
    end

    if currentSemicolonCount == 1
        updateDerivationSteps!("[assignments]", "[key-assign];")
    else
        updateDerivationSteps!("[assignments]", "[key-assign]; [assignments]")
    end
    keyAssignmentCount += 1
    processIII(aids3)
    if currentSemicolonCount > 1
        return processII(aids2_remainder)
    elseif !isempty(strip(aids2_remainder))
        # Ensure no extra content after the last semicolon in case of exactly one semicolon
        throw("Invalid Instructions: Extra content after final ; :  $(join(aids2_remainder, " "))''.")
    end

    return true
end

function processIII(aids3::AbstractString)
    global assignments
    push!(assignments, aids3)
    tokens = split(strip(aids3), " ")
    if length(tokens) != 4
        throw("Expected exactly four words, received $(length(tokens)), $(join(tokens, " "))")
    elseif tokens[1] != "key"
        throw("Expected 'key', received $(tokens[1])")
    elseif tokens[3] != "="
        throw("Expected '=', received $(tokens[3])")
    end

    updateDerivationSteps!("[key-assign]", "key [x] = [y]")
    processIV(tokens[2])
    processV(tokens[4])
    return true
end

function processIV(aids4::AbstractString)
    aids4 = strip(aids4)
    if !in(aids4, validX)
        throw("Invalid value for [x]: $aids4. Expected one of: $(join(validX, ", "))")
    end

    if aids4 in assignedKeys
        throw("The key '$aids4' has already been assigned.")
    end

    push!(assignedKeys, aids4)
    updateDerivationSteps!("[x]", "$aids4")
    return true
end

function processV(aids5::AbstractString)
    aids5 = strip(aids5)
    if !in(aids5, validY)
        throw("Invalid value for [y]: $aids5. Expected one of: $(join(validY, ", "))")
    end
    updateDerivationSteps!("[y]", "$aids5")
    return true
end
