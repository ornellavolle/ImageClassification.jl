# Définition d'un type abstrait : AbstractAnimals 
# avec différents types concrets héritant de ce type abstrait (struct)
# et utilisation du multiple dispatching pour personnaliser l’affichage (Base.show)

abstract type AbstractAnimals end

mutable struct Cheetah <: AbstractAnimals
    # poids léger et haute vitesse
    name::String
    weight::Int
    speed::Int
end

mutable struct Hyena <: AbstractAnimals
    # trapue et vit en clan
    name::String
    stocky::Bool
    clan::Int
end


mutable struct Jaguar <: AbstractAnimals
    # très bon nageur et a une mâchoire extrêmement puissante    
    name::String
    swimmer::Bool
    jaw_strength::String
end

mutable struct Tiger <: AbstractAnimals
    # rayures en cm, très territorial et force en newton
    name::String
    avg_thickness_scratches::Int
    territorial::Bool
    strength::Int
end

function describe(animal::AbstractAnimals)
    if animal isa Cheetah
        println("Le guépard ", animal.name, " pèse ", animal.weight, " kg et peut aller jusqu'à ", animal.speed, " km/h.")
    elseif animal isa Hyena
        println("La hyène ", animal.name, " vit dans un clan de ", animal.clan, " individus et .")
    elseif animal isa Jaguar
        println("Le jaguar ", animal.name, " est un excellent nageur: ", animal.swimmer, " et sa mâchoire est ", animal.jaw_strength)
    elseif animal isa Tiger
        println("Le tigre ", animal.name, " est territorial: ", animal.territorial, " et sa force est ", animal.strength, " N.")
    end
end

# Nous avions initiallement fait ça mais ce n'est pas correcte et ça ne respecte pas le multipal 
# dispaching, nous avons donc modifié (avec toi) en ça : 


function Base.show(io::IO,animal::Cheetah)
        println(io,"Le guépard ", animal.name, " pèse ", animal.weight, " kg et peut aller jusqu'à ", animal.speed, " km/h.")
end

function Base.show(io::IO,animal::Hyena)
        println(io,"La hyène ", animal.name, " vit dans un clan de ", animal.clan, " individus et ", animal.stocky ? "est" : "n'est pas"," trapue.")
end    

function Base.show(io::IO,animal::Jaguar)
        println(io,"Le jaguar ", animal.name, animal.swimmer ? "est un excellent nageur" : "ne nage malheureusment pas bien", " et sa mâchoire est ", animal.jaw_strength)
end    

function Base.show(io::IO,animal::Tiger)
        println(io,"Le tigre ", animal.name, animal.territorial ? " est " : " n'est pas ", "territorial et sa force est de ", animal.strength, " N.")
end

function Base.show(io::IO,animals::Vector{<:AbstractAnimals})
    for i in eachindex(animals)
        println(io, animals[i])
    end
end