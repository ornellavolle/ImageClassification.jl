#import des packages
using MLJ
using Flux
import MLJFlux
import MLUtils
import MLJIteration  # pour 'skip'
using ImageClassification

using FileIO, Images  # pour charger tes images
using Plots

export load_image, load_dataset

gr(size=(600, 300*(sqrt(5)-1))); #fixe la taille des figures (ici 600px de large)


# constante du répertoire :
const root_dir = joinpath(dirname(@__FILE__),"..","..")

#chargement du jeu de données cheetah...
# determination des chemins qui vont aux dossiers
train_dir = joinpath(root_dir,joinpath("data","train"))
val_dir   = joinpath(root_dir,joinpath("data","validation"))

load_dataset()

