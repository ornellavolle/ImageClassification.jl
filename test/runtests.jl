using Test
using ImageClassification

@testset "ImageClassification.jl" begin
        include("unit/test_load.jl")
        include("unit/test_interactions.jl")
        include("unit/test_operateurs.jl")
        include("unit/test_random_sample.jl")
        include("unit/test_animals.jl")
end

# lancer les tests : test