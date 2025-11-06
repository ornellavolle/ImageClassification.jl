using Test
using ImageClassification

@testset "Tests création et description d'animaux" begin

    animal = make_random_animal("Cheetah")
    @test animal isa Cheetah
    @test hasfield(Cheetah, :name)
    @test hasfield(Cheetah, :speed)
    @test typeof(animal.name) == String

    cheetah = Cheetah("Flash", 60, 110)

    # Expansion de la macro dans le module ImageClassification
    ex = macroexpand(ImageClassification, :(@describe(cheetah)))
    @test isa(ex, Expr)
end
