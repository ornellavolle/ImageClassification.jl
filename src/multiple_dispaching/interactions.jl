##### Multiple dispaching : #####

function interact(a::AbstractAnimals, b::AbstractAnimals)
    println(a.name, " observe prudemment ", b.name, ".")
end

function interact(a::Cheetah, b::Hyena)
    println("Le guépard ",a.name, " tente de voler une proie à la hyène ", b.name, " du clan de ", b.clan, " membres !")
end

function interact(a::Hyena, b::Cheetah)
    println("La hyène ", a.name, " et son clan encerclent le guépard ", b.name, " !")
end

function interact(a::Tiger, b::Jaguar)
    println("Le tigre ",a.name, " montre sa force de ", a.strength, " N face au jaguar ", b.name, " à la mâchoire ", b.jaw_strength, " !")
end

function interact(a::Jaguar, b::Cheetah)
    println("Le jaguard ", a.name, " ignore le guépard ", b.name, " : il préfère chasser près de l’eau.")
end

function interact(a::Hyena, b::Hyena)
    println("Les hyènes ", a.name, " et ", b.name, " rient ensemble et chassent en meute.")
end

function interact(a::Tiger, b::Tiger)
    if a.territorial && b.territorial
        println("Les tigres ", a.name, " et ", b.name, " se disputent le territoire !")
    else
        println("Les tigres ", a.name, " et ", b.name, " cohabitent paisiblement.")
    end
end
