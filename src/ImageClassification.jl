module ImageClassification

# exports : 

export load_image, load_dataset
export Cheetah, Hyena, Jaguar, Tiger
export interact
export ⊔
export AnimalSampler, get_animal_dir
export rand, rand_all
export Animal, Carnivore, Herbivore, Cerf, Loup
export describe, random_value, make_random_animal, interact
export process_cheetah, process_hyena, process_jaguar, process_tiger
export MyConvBuilder, MLJFluxexport
export load_lux_model, preprocess_lux_image, predict_lux_class, predict_lux_probabilities

# Créer des nouveaux types : 

include("type_creation/type_creation.jl")

# Lire et redimensionner des images : 

include("load/load.jl")

# Animals personnalise l'affichage de différents struct : 

include("multiple_dispaching/animals.jl")

# Interactions entre animaux : multiple dispaching : 

include("multiple_dispaching/interactions.jl")

# Opérations avec : ⊔

include("multiple_dispaching/operareur.jl")

# Créer des échantillons aléatoires d'animaux : 

include("random_sample/random_sample.jl")

# Métaprogrammation : 

include("metaprogrammation/metaprogramming.jl")

# Lux classification :
include("classificationLux/classification_lux.jl")

end
