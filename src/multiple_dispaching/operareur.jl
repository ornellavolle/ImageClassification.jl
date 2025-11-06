##### Opérateurs et double dispaching : #####

# liste des opérateurs Julia reconnus : 
# https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm

# Nous voulons utiliser celui la : ⊔, 
# Nous avons déjà vérifié qu'il ets bien reconnu grâce à cette commande : Base.isoperator(:⊔)
# qui nous a renvoyé true

# Définition générique de l'opérateur : AbstractAnimals, AbstractAnimals

a::AbstractAnimals ⊔ b::AbstractAnimals = string(a.name, " et ", b.name, " n'ont pas d'opérateurs pour l'instant :(")

# Cas spécialisé pour (Cheetah, Hyena):
a::Cheetah ⊔ b::Hyena = string("Le guépart ", a.name, " et le hyène ", b.name," ne s'aiment pas du tout")

# différence de force entre 2 tigres :
# Cas spécialisé pour (Tiger, Tiger):
a::Tiger ⊔ b::Tiger = string("Le tigre ",a.name," a une force de ",a.strength,"N, tandis que ",b.name," lui, en a une de ",b.strength,"N !")
