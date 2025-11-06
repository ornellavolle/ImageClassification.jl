using Test
using ImageClassification

@testset "Tests interactions entre animaux" begin
    # test des interactions
    c = make_random_animal("Cheetah")
    h = make_random_animal("Hyena")
    t = make_random_animal("Tiger")
    j = make_random_animal("Jaguar")

    # on s'assure que les méthodes existent pour chaque combinaison importante
    @test hasmethod(interact, Tuple{Cheetah, Hyena})
    @test hasmethod(interact, Tuple{Hyena, Cheetah})
    @test hasmethod(interact, Tuple{Tiger, Tiger})
    @test hasmethod(interact, Tuple{Tiger, Jaguar})

    # Vérifie que l'appel ne lève pas d'erreur
    @test interact(c, h) === nothing
    @test interact(t, j) === nothing
end
