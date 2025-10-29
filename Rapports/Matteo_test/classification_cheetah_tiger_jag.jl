
#Il faut pas importer tout de suite ces pkg parce que sinon ça créé des confusion entre les fonctions surtout 
#la fction load()


#using Flux
#import MLJFlux
#import MLUtils
#import MLJIteration  # pour 'skip'
#using ImageClassification

import FileIO
import Images
using FileIO
using Images  # pour charger tes images
using Plots

gr(size=(600, 300*(sqrt(5)-1))); #fixe la taille des figures (ici 600px de large)



# Chemin vers ton dossier 'data'
base_path = "/Users/matteoschweizer/Documents/GitHub/ImageClassification.jl/data"

# Fonction pour charger les images et leur attribuer une étiquette
function load_images_from_folder(folder_path)
    classes = readdir(folder_path)
    images = []
    labels = []

    for (i, class) in pairs(classes)
        class_path = joinpath(folder_path, class)
        for img_file in readdir(class_path)
            img_path = joinpath(class_path, img_file)
            img = FileIO.load(img_path)
            push!(images, img)
            push!(labels, class)  # tu peux aussi stocker i pour un label numérique
        end
    end

    return images, labels
end

# Chargement des datasets
train_path = joinpath(base_path, "train")
val_path = joinpath(base_path, "validation")

train_images, train_labels = load_images_from_folder(train_path)
val_images, val_labels = load_images_from_folder(val_path)

println("Train set: $(length(train_images)) images")
println("Validation set: $(length(val_images)) images")

#Conversion au format MLJ
using MLJ
train_labels = coerce(train_labels, Multiclass)
val_labels = coerce(val_labels, Multiclass)

#Vérification des types scientifiques
@assert scitype(train_images) <: AbstractVector{<:Image}
@assert scitype(train_labels) <: AbstractVector{<:Finite}


#Visualiser une image
train_images[2500]