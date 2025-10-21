
# constante du répertoire :
const root_dir = joinpath(dirname(@__FILE__),"..")

# Fonction pour charger une image en tenseur 4D, et la redimensionner en 64*64 :
function load_image(path; dataset::AbstractString = "train", size=(64,64))
    img = load(joinpath(root_dir,joinpath("data",dataset),path))
    #typeof(img) # Charger l'image
    img = imresize(img,size)   # Redimensionner (fonction sûre)
    return img
end


# fonction pour charger l'ensemble des données d'un répertoire donné : base_dir
# l'ensemble des images, redimensionnées en (64*64) sont stockées dans le vecteur X
function load_dataset(;dataset::AbstractString = "train")
    imgs = []  # images : 
    # enregistrées sous la forme de matrices pour chaque photo avec comme éléments la définitions de couleurs RGB de chaque pixel 
    labels = []  # labels
    base_dir = joinpath(root_dir,"data/$dataset")
    classes =  readdir(base_dir)
    for (i, cls) in enumerate(classes)
        class_dir = joinpath(base_dir, cls)    
        for path in readdir(class_dir)
            img = load_image(joinpath(cls,path); dataset=dataset)
            push!(imgs, img)
            push!(labels, i)
        end
    end
    return imgs
end

