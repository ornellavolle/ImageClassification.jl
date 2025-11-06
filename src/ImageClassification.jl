module ImageClassification

# Packages à importer : 
using Images, ImageIO, FileIO
using ImageTransformations
using MLJFlux

# exports : 
export load_image, load_dataset
export Cheetah, Hyena, Jaguar, Tiger
export interact
export ⊔
export AnimalSampler, get_animal_dir
export rand_one_animal, rand_each_animal, rand_all
export Animal, Carnivore, Herbivore, Cerf, Loup
export describe, random_value, make_random_animal, interact
export process_cheetah, process_hyena, process_jaguar, process_tiger
export MyConvBuilder, MLJFlux
export load_images_from_folder

# Fonction pour charger les images et leur attribuer une étiquette :

include("load_image/load_images_from_folder.jl")

# Création d'une fonction qui détermine la forme du réseau de neurone, fonction qui provient du package MLJFlux : 

include("recipe_4_neural_network/recipe_4_neural_network.jl")

# Créer des nouveaux types : 

include("type_creation/type_creation.jl")

# Lire et redimensionner des images : 

include("load_image/load.jl")

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

end
