##### Opérateurs et double dispaching : #####

include("animals.jl")

# liste des opérateurs Julia reconnus : 
# https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm

# Nous voulons utiliser celui la : ⊔, 
# Nous avons déjà vérifié qu'il ets bien reconnu grâce à cette commande : Base.isoperator(:⊔)
# qui nous a renvoyé true

# Définition générique de l'opérateur : AbstractAnimals, AbstractAnimals

⊔(a::AbstractAnimals, b::AbstractAnimals) = length(a.name) + length(b.name)

# Cas spécialisé pour (Cheetah, Hyena):
⊔(a::Cheetah, b::Hyena) = a.weight / b.clan

# Cas spécialisé pour (Hyena, Cheetah):
⊔(a::Hyena, b::Cheetah) = a.clan * b.speed

# différence de force entre 2 tigres :
# Cas spécialisé pour (Tiger, Tiger):
⊔(a::Tiger, b::Tiger) = a.strength - b.strength
