module ImageClassification

# Packages à importer : 
using Images, ImageIO, FileIO
using ImageTransformations

# exports : 
export load_image, load_dataset
export Cheetah, Hyena, Jaguar, Tiger
export interact
export ⊔

# Lire et redimensionner des images : 

include("load_image/load.jl")

# Animals personnalise l'affichage de différents struct : 

include("multiple_dispaching/animals.jl")

# Interactions entre animaux : multiple dispaching : 

include("multiple_dispaching/interactions.jl")

# Opérations avec : ⊔

include("multiple_dispaching/operareur.jl")

# Créer un échantillon aléatoire : 

# include("random_sample/random_sample_of_animals.jl")

end
