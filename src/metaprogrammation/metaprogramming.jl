using Random

#dictionary to introduce the animals
const ANIMAL_PROPERTIES = Dict(
    "Cheetah" => [:name, :weight, :speed],
    "Hyena"   => [:name, :stocky, :clan],
    "Jaguar"  => [:name, :swimmer, :jaw_strength],
    "Tiger"   => [:name, :avg_thickness_scratches, :territorial, :strength]
)


#macro to describe each animal like print its fields
macro describe(animal_expr)
    animal = esc(animal_expr)
    return quote
        println("=== Description automatique ===")
        println("Type: ", typeof($animal))
        for f in fieldnames(typeof($animal))
            println("$(f): ", getfield($animal, f))
        end
        println("===============================")
    end
end


# create the structures dynamically instead of one by one 
abstract type AbstractAnimals end

for (animal, fields) in ANIMAL_PROPERTIES
    struct_sym = Symbol(animal)
    @eval mutable struct $(struct_sym) <: AbstractAnimals
        $(fields...)
    end
end



#generate random values fro each field for each animal type
function random_value(field)
    if field == :name
        return ["Chester","Flash","Speedy","Dart","Bolt"][rand(1:5)]
    elseif field == :weight
        return rand(50:70)
    elseif field == :speed
        return rand(100:120)
    elseif field == :stocky
        return rand(Bool)
    elseif field == :clan
        return rand(20:40)
    elseif field == :swimmer
        return rand(Bool)
    elseif field == :jaw_strength
        return ["Très puissante","Extrêmement puissante","Puissante"][rand(1:3)]
    elseif field == :avg_thickness_scratches
        return rand(5:25)
    elseif field == :territorial
        return rand(Bool)
    elseif field == :strength
        return rand(1400:1800)
    end
end

#a function to craete random animals
function make_random_animal(animal_type::String)
    fields = ANIMAL_PROPERTIES[animal_type]
    values = [random_value(f) for f in fields]
    struct_sym = Symbol(animal_type)
    return eval(:( $(struct_sym)($(values...)) ))
end


#interact functions
function interact(a::AbstractAnimals, b::AbstractAnimals)
    println(a.name, " observe prudemment ", b.name, ".")
end

function interact(a::Cheetah, b::Hyena)
    println("Le guépard ", a.name, " tente de voler une proie à la hyène ", b.name, " du clan de ", b.clan, " membres !")
end

function interact(a::Hyena, b::Cheetah)
    println("La hyène ", a.name, " et son clan encerclent le guépard ", b.name, " !")
end

function interact(a::Tiger, b::Tiger)
    if a.territorial && b.territorial
        println("Les tigres ", a.name, " et ", b.name, " se disputent le territoire !")
    else
        println("Les tigres ", a.name, " et ", b.name, " cohabitent paisiblement.")
    end
end

function interact(a::Tiger, b::Jaguar)
    println("Le tigre ", a.name, " montre sa force de ", a.strength, " N face au jaguar ", b.name, " à la mâchoire ", b.jaw_strength, " !")
end

function interact(a::Jaguar, b::Cheetah)
    println("Le jaguar ", a.name, " ignore le guépard ", b.name, " : il préfère chasser près de l'eau.")
end

function interact(a::Hyena, b::Hyena)
    println("Les hyènes ", a.name, " et ", b.name, " rient ensemble et chassent en meute.")
end

function interact(a::Tiger, b::Cheetah)
    println("Le tigre ", a.name, " observe prudemment le guépard ", b.name, ".")
end

# operators 
⊔(a::Cheetah, b::Hyena) = a.weight / b.clan
⊔(a::Hyena, b::Cheetah) = a.clan * b.speed
⊔(a::Tiger, b::Tiger) = a.strength - b.strength
⊔(a::Jaguar, b::Cheetah) = length(a.name) + length(b.name)
⊔(a::Tiger, b::Cheetah) = a.strength / b.speed
⊔(a::AbstractAnimals, b::AbstractAnimals) = length(a.name) + length(b.name)


# metaprogramming to generate functions 
for animal in keys(ANIMAL_PROPERTIES)
    func_name = Symbol("process_", lowercase(animal))
    @eval begin
        function $(func_name)()
            println("\n=== Processing $(string($(QuoteNode(animal)))) ===")
            animal_instance = make_random_animal($(QuoteNode(animal)))
            @describe animal_instance

            # example of  interaction with a random generated cheetah
            cheetah = make_random_animal("Cheetah")
            if $(QuoteNode(animal)) != "Cheetah"
                interact(animal_instance, cheetah)
                println("⊔ with Cheetah: ", animal_instance ⊔ cheetah)
            end

            return animal_instance
        end
    end
end



































