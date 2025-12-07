using Test
using ImageClassification

@testset "ImageClassification.jl" begin
        include("unit/load.jl")
        include("unit/interactions.jl")
        include("unit/operateurs.jl")
        include("unit/random_sample.jl")
        include("unit/animals.jl")
end

