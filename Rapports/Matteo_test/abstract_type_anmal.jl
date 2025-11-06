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

c=Cerf(180.0)

crier(c)

l=Loup("cheval")
crier(l)

subtypes(Animal)
subtypes(Carnivore)