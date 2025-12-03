using ImageClassification

import FileIO
import Images
using FileIO
using Images
using Plots
import MLJFlux
using Random
using Flux
using MLUtils
using MLJ
using CategoricalArrays
using ScientificTypes

gr(size=(600, 300*(sqrt(5)-1))); #fixe la taille des figures (ici 600px de large)

# Chemin vers ton dossier 'data' : 

# constante du répertoire :
const root_dir = joinpath(dirname(@__FILE__),"..","..")

# determination des chemins qui vont aux dossiers
train_dir = joinpath(root_dir,joinpath("data"))

# Chargement des datasets
train_path = joinpath(train_dir, "train")
val_path = joinpath(train_dir, "validation")

train_images, train_labels = load_dataset(dataset="train")
val_images, val_labels = load_dataset(dataset="validation")

train_labels_str = String.(train_labels)
val_labels_str = String.(val_labels)
#Conversion au format MLJ

train_labels = coerce(train_labels_str, Multiclass)
val_labels = coerce(val_labels, Multiclass)

#Vérification des types scientifiques
@assert scitype(train_images) <: AbstractVector{<:Image}
@assert scitype(train_labels) <: AbstractVector{<:Finite}

#Visualiser une image
train_images[2520]

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

# Définir le constructeur CNN (déjà défini avant)

# Paramètres de ton modèle
clf = ImageClassifier(
    builder = MyConvBuilder(3, 16, 32, 64),  # filtres (3x3) et nombre de canaux
    batch_size = 32,                         # taille des lots d'entraînement
    epochs = 1,                             # nombre d’époques
    rng = Random.default_rng(),              # graine aléatoire
)

#Liaison (binding) du modèle
mach = machine(clf, train_images, train_labels);

#création d'un subset aléatoire de 500 images du jeu de donnée cheetah...

subset_size = 500
idx = randperm(length(train_images))[1:subset_size]

images_subset = train_images[idx]
labels_subset = train_labels[idx]

#Liaison (binding) du modèle

#Si on veut utiliser juste un subset du dataset
mach = machine(clf, images_subset, labels_subset)

#si on veut utiliser tout le dataset
# mach = machine(clf, train_images, train_labels)

#entrainement pour 10 épochs
fit!(mach, verbosity=2)

report(mach)

# Prédictions
ŷ = predict(mach, val_images)
y_pred = mode.(ŷ)

# Évaluation
println("Accuracy = ", accuracy(y_pred, val_labels))
cm = confusion_matrix(val_labels, y_pred)


