module imageclassification

# Packages à importer : 
using Images, ImageIO, FileIO
using ImageTransformations

# Configuration du dataset :
root = "../../Desktop/ImageClassification.jl/"
train_dir = joinpath(root,"data/train")
test_dir  = joinpath(root,"data/validation")

# Définition des classes :
classes = readdir(train_dir)
println("Classes trouvées : ", classes)
n_classes = length(classes)

# Fonction pour charger une image en tenseur 4D, et la redimensionner en 64*64 :
function load_image(path; size=(64,64))
    img = load(path)
    typeof(img) # Charger l'image
    img = imresize(img,size)   # Redimensionner (fonction sûre)
    return img
end

# exemple d'utilisation de la fonction load_image :
# load_image(joinpath(train_dir,"cheetah","cheetah_000_resized.jpg"))

# fonction pour charger l'ensemble des données d'un répertoire donné : base_dir
# l'ensemble des images, redimensionnées en (64*64) sont stockées dans le vecteur X
function load_dataset(base_dir; dif_classes = classes)
    X = []  # images : 
    # enregistrées sous la forme de matrices pour chaque photo avec comme éléments la définitions de couleurs RGB de chaque pixel 
    y = []  # labels
    for (i, cls) in enumerate(dif_classes)
        class_dir = joinpath(base_dir, cls)    
        for file in readdir(class_dir)
            img_path = joinpath(class_dir, file)
            img = load_image(img_path)
            push!(X, img)
            push!(y, i)
        end
    end
    return X
end

# exemple, on importe toute les données de train : 
# load_dataset(train_dir)


# Classification : utiliser CNN
# Créer un type Struct selon la nature de l'image : cheetah...

end
