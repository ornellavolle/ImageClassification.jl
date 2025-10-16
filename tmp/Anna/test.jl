using Flux
using Images, ImageIO
using FileIO
using Statistics
using Random
using CUDA

# chemin vers data
train_dir = "data/train"
test_dir = "data/validation"

# Liste des classes
classes = readdir(train_dir)
println("Classes trouvées : ", classes)
n_classes = length(classes)


# TENSEUR : 
# Boîte de nombres multidimensionnelle, généralisation des scalaires, vecteurs et matrices :
# Fonction pour charger une image et la convertir en tenseur
# Type de donnée	          Exemple	         Dimension	Nom
# Nombre simple	              3.14	             0D	        scalaire
# Liste de nombres	          [1, 2, 3]          1D	        vecteur
# Tableau à 2 axes	          [[1 2 3]; [4 5 6]] 2D	        matrice
# Tableau à plusieurs axes	  image 64×64×3	     3D+	    tenseur

function load_image(path; size=(64,64))
    img = load(path)
    img = Images.imresize(img, size)          # redimensionner
    img = Float32.(channelview(img)) ./ 255f0 # normaliser entre 0 et 1
    return img
end

# Charger toutes les images d'un dossier
function load_dataset(base_dir, classes)
    X = []
    y = Int[]
    for (i, cls) in enumerate(classes)
        for file in readdir(joinpath(base_dir, cls))
            img_path = joinpath(base_dir, cls, file)
            img = load_image(img_path)
            push!(X, img)
            push!(y, i)
        end
    end
    return X, y
end

X_train, y_train = load_dataset(train_dir, classes)
X_test, y_test = load_dataset(test_dir, classes)

# Création du modèle CNN : 
model = Chain(
    Conv((3,3), 3=>16, relu),
    MaxPool((2,2)),
    Conv((3,3), 16=>32, relu),
    MaxPool((2,2)),
    Flux.flatten,
    Dense(32*16*16, 128, relu),
    Dense(128, n_classes),
    softmax
) |> gpu

# fonction de perte et optimisateur : 
loss(x, y) = Flux.Losses.logitcrossentropy(model(x), y)
opt = ADAM(1e-3)
