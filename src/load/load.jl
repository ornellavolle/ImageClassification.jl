using Images, ImageIO, FileIO
using ImageTransformations

# constante du répertoire :
const root_dir = joinpath(dirname(@__FILE__),"..","..")

# Fonction pour charger une image et la redimensionner en 64*64 :

function load_image(path; dataset::AbstractString = "train", size=(200,200))
    full_path = joinpath(root_dir, "data", dataset, path)
    # Charger l'image
    img = FileIO.load(full_path)  # `load` doit venir de FileIO
    # Vérifier que l'image est en RGB
    img_rgb = colorview(RGB, img)  # si ce n'est pas déjà le cas
    # Redimensionner
    img_resized = imresize(img_rgb, size)
    return img_resized
end


# fonction pour charger l'ensemble des données d'un répertoire donné : base_dir
# l'ensemble des images, redimensionnées en (64*64) sont stockées dans le vecteur X
function load_dataset(;dataset::AbstractString = "train")
    #classes = readdir(folder_path)
    imgs = []  # images : 
    # enregistrées sous la forme de matrices pour chaque photo avec comme éléments 
    # la définitions de couleurs RGB de chaque pixel 
    labels = []  # labels
    base_dir = joinpath(root_dir,"data/$dataset")
    classes =  readdir(base_dir)
    for (i, cls) in enumerate(classes)
        class_dir = joinpath(base_dir, cls)    
        for path in readdir(class_dir)
            img = load_image(joinpath(cls,path); dataset=dataset)
            push!(imgs, img)
            push!(labels, cls)
        end
    end
    return imgs, labels
end


