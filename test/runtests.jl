using Test
using ImageClassification

@testset "ImageClassification.jl" begin
    @testset "Chargement" begin
        include("unit/test_load.jl")
    end

    @testset "Interactions" begin
        include("unit/test_interactions.jl")
    end

    @testset "Opérateurs" begin
        include("unit/test_operateurs.jl")
    end

    @testset "Échantillonnage aléatoire" begin
        include("unit/test_random_sample.jl")
    end

    @testset "Création et description d'animaux" begin
        include("unit/test_animals.jl")
    end
end

# lancer les tests : test