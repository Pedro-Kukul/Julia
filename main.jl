include("derivation.jl")
include("helpers.jl")
include("pbasic.jl")

function main()
    while true
        try
            displayGrammar()
            print(colorize("Enter Instructions: ", :blue, :white))
            aids = readline()
            if processI(aids)
                generatePBASIC(aids)
            end
        catch e
            println(colorize("Error: $e", :white, :red))
        end
    end
end

main()