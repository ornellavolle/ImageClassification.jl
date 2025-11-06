
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
train_images[2520]

import MLJFlux
#using Flux
#using MLUtils  # pour flatten
#using Random

# --- Définition du constructeur ---
struct MyConvBuilder
    filter_size::Int      # taille des filtres de convolution (ex: 3)
    channels1::Int        # nombre de canaux dans le 1er bloc conv
    channels2::Int
    channels3::Int
end

function MLJFlux.build(b::MyConvBuilder, rng, image_size, n_out, n_channels)
    # image_size = (height, width)
    k, c1, c2, c3 = b.filter_size, b.channels1, b.channels2, b.channels3
    mod(k, 2) == 1 || error("`filter_size` must be odd.")
    p = div(k - 1, 2)  # padding pour garder même taille après conv
    init = Flux.glorot_uniform(rng)

    front = Chain(
        Conv((k, k), n_channels => c1, pad=(p, p), relu, init=init),
        MaxPool((2, 2)),
        Conv((k, k), c1 => c2, pad=(p, p), relu, init=init),
        MaxPool((2, 2)),
        Conv((k, k), c2 => c3, pad=(p, p), relu, init=init),
        MaxPool((2, 2)),
        MLUtils.flatten
    )

    # Taille de sortie du CNN avant la couche fully connected
    d = Flux.outputsize(front, (image_size..., n_channels, 1)) |> first

    # Réseau complet
    return Chain(front, Dense(d, n_out, init=init))
end


# Charger le modèle MLJFlux.ImageClassifier
ImageClassifier = @load ImageClassifier pkg=MLJFlux

# Définir ton constructeur CNN (déjà défini avant)
# struct MyConvBuilder ... (comme dans ton code précédent)

using Random
# Paramètres de ton modèle
clf = ImageClassifier(
    builder = MyConvBuilder(3, 16, 32, 64),  # filtres (3x3) et nombre de canaux
    batch_size = 32,                         # taille des lots d'entraînement
    epochs = 10,                             # nombre d’époques
    rng = Random.default_rng(),              # graine aléatoire
)

#Liaison (binding) du modèle
mach = machine(clf, train_images, train_labels);

using Flux
using MLUtils
#entrainement pour 10 épochs
fit!(mach, verbosity=2);



#Pour essayer de faire tourner le modèle sur un sous ensemble et 
#voir la conv: importer des données photos julia

using Random

subset_size = 500
idx = randperm(length(train_images))[1:subset_size]

images_subset = train_images[idx]
labels_subset = train_labels[idx]

mach = machine(clf, images_subset, labels_subset)
fit!(mach, verbosity=2)
