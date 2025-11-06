using Test
using ImageClassification

@testset "Tests échantillonnage d'images" begin
    s = AnimalSampler("/tmp", ["Cheetah", "Hyena", "Tiger", "Jaguar"])
    @test s isa AnimalSampler
    @test get_animal_dir(s, "Cheetah") == joinpath("/tmp", "data", "train", "Cheetah")

    @test hasmethod(rand_one_animal, Tuple{AnimalSampler, String, Int})
    @test hasmethod(rand_each_animal, Tuple{AnimalSampler, Int})
    @test hasmethod(rand_all, Tuple{AnimalSampler, Int})
end
