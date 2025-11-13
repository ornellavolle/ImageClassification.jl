using ImageClassification

########## Tests des opérations avec : ⊔ ##########

include("animals_example.jl")

animals[1] ⊔ animals[6]
animals[16] ⊔ animals[17]
# deux animaux pour qui il n'y a pas de ⊔ définit, on va donc utiliser le général : 
animals[12] ⊔ animals[11]
