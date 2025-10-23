using Markdown
using InteractiveUtils
using Pkg

#Pkg.activate("Project.toml")
#Pkg.add("Flux")

#load data pour les hyénes
#il faut dormaliser nos données pour qu'on puisse les mettre sous la même taille
#trainData = Flux.DataLoader((X, Y), batchsize=32)
#trainData = "data/train/cheetah_train_resized"
#testData  = "data/validation/cheetah_validation_resized"

#length(trainData)

#Pkg.add("Images")
#Pkg.add("PyPlot")
#using Images, PyPlot

#img = load("cheetah_000_resized.jpg")

#i = 1
#px = Vector{Float64}(undef, size(img,1)*size(img,2))
#for y in 1:size(ps,2)
#    for x in 1:size(ps,1)
   #     px[i] = Float64(img[x,y].r) + Float64(img[x,y].g) +  Float64(img[x,y].b)
  #      i += 1
 #   end
#end
#px ./ 3;
#imshow(reshape(px, size(img,1), size(img,2)); cmap="gray")
#########################
#########################
#########################
#Pkg.add("Images")
#Pkg.add("ImageIO")
#Pkg.add("FileIO")
#Pkg.add("Statistics")
#Pkg.add("Random")
using Flux
using Images, ImageIO
using FileIO
using Statistics
using Random

# chemin vers data
train_dir = "data/train"
test_dir = "data/validation"

# Liste des classes
classes = readdir(train_dir)
#readdir returns just the names in the directory as is; 
#when join is true, it returns joinpath(dir, name) for each name so that the 
#returned strings are full paths. If you want to get absolute paths back, 
#call readdir with an absolute directory path and join set to true.
#En résumé readdir va chercher le noms de chaque dossier dans train_dir

println("Classes trouvées : ", classes)
n_classes = length(classes)
#taille de la classe


# TENSEUR : 
# Boîte de nombres multidimensionnelle, généralisation des scalaires, vecteurs et matrices :
# Fonction pour charger une image et la convertir en tenseur
# Type de donnée	          Exemple	         Dimension	Nom
# Nombre simple	              3.14	             0D	        scalaire
# Liste de nombres	          [1, 2, 3]          1D	        vecteur
# Tableau à 2 axes	          [[1 2 3]; [4 5 6]] 2D	        matrice
# Tableau à plusieurs axes	  image 64×64×3	     3D+	    tenseur

function load_image(path; size=(400,400))
    #fonction qui va charger les images en les normalisant avec la taille
    img = load(path)
    img = Images.imresize(img, size)# redimensionner
    img = Float32.(channelview(img)) ./ 255f0 # normaliser entre 0 et 1
    return img
end
load_image("/Users/admin/Desktop/MIASHS/MasterM1SSD/CoursRJulia/GitHub_package/ImageClassification.jl/data/validation/cheetah/cheetah_000_val_resized.jpg")

#Charger toutes les images d'un dossier
function load_dataset(base_dir, classe)
    X = []
    #créer un tableau x vide
    y = Int[]
    #créer un tableau int y vide => car c'est pour créer une matrice d'int avec nos matrice d'images
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
