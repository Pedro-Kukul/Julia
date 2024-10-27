include("derivation.jl")

function main()
    while true
        try
            displayGrammar()
            print(colorize("Enter Instructions: ", :blue, :white))
            aids = readline()
            processI(aids)
        catch e
            println(colorize("Error: $e", :white, :red))
        end
    end
end

main()