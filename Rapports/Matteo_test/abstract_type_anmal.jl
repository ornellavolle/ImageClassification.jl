abstract type Animal end
abstract type Carnivore <: Animal end
abstract type Herbivore <: Animal end

struct Loup <: Carnivore
    nom::String 
end

struct Cerf <: Herbivore
    poids::Float64 
end

crier(::Cerf) = "Bramer"
crier(::Loup) = "Hurler"

