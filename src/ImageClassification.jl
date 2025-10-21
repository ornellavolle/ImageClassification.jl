module ImageClassification

# Packages à importer : 
using Images, ImageIO, FileIO
using ImageTransformations

# Lire des images : 
export load_image, load_dataset

include("load.jl")

# Animals personnaliser l'affichage de différents struct : 

export Cheetah, Hyena, Jaguar, Tiger
include("animals.jl")


# Classification : utiliser CNN
# Créer un type Struct selon la nature de l'image : cheetah...

end
