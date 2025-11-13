using Test
using ImageClassification

@testset "Tests chargement d'images" begin

    # Vérification que les fonctions acceptent les bons arguments :
    @test hasmethod(load_image, Tuple{AbstractString})
    @test hasmethod(load_dataset, Tuple{})

    # On a choisis de ne pas tester la lecture réelle d’images ici (très lourd)
    # mais on vérifie qu’elles ne plantent pas quand on passe un chemin inexistant :
    @test_throws ArgumentError load_image("inexistant.jpg")
end
