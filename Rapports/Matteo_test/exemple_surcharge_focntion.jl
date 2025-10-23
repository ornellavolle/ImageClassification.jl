#création d'une fonction simple qui donne la soustraction de mes entrées

function soustraction(x::Int, y::Int)
    x-y
end

soustraction(2,4)

soustraction(2.5,8)

soustraction(y::string)=println("on ne peut pas soustraire un string")

say_hello(name::String) = println("Bonjour, $name !")
