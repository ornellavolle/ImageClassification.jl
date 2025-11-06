using Test
using ImageClassification

@testset "Tests opérateur ⊔" begin

    c = Cheetah("Chester", 60, 110)
    t = Tiger("Rajah", 8, true, 1600)

    # Vérifie que les combinaisons produisent bien un résultat
    @test typeof(c ⊔ t) <: Union{String, Number}
end
