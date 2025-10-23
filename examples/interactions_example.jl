using ImageClassification

########## Tests du Multiple Dispaching  ##########

include("animals_example.jl")

# interaction entre Cheetah et Hyena : 
interact(animals[5],animals[7])

# interaction entre Hyena et Cheetah : 
interact(animals[7],animals[5])

# interaction entre Tiger et Jaguar : 
interact(animals[19],animals[13])

# interaction entre Jaguar et Cheetah : 
interact(animals[13],animals[4])

# interaction entre deux Hyena : 
interact(animals[7],animals[8])

# interaction entre deux Tiger : 
interact(animals[19],animals[17])