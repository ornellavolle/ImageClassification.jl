# on va créer un échantillon de photos sur l'ensemble des animaux dans le train : 

using Random, Glob, FileIO, Images

# --- Fonction pour échantillonner aléatoirement des images ---
function sample_images(animal_dir::String, n::Int)
    # lister toutes les images jpg dans le répertoire
    all_files = glob("*.jpg", animal_dir)
    # vérifier que n ne dépasse pas le nombre de fichiers
    n = min(n, length(all_files))
    # échantillonnage aléatoire sans remise
    sampled_files = Random.sample(all_files, n, replace=false)
    # charger les images
    return [load(f) for f in sampled_files]
end

# --- Exemple d'utilisation ---
train_dir = "file/train"   # dossier train
animals = ["cheetah", "hyena", "tiger", "lion"]
n_sample = 5               # taille de l'échantillon par animal

# dictionnaire pour stocker les images échantillonnées
sampled_images = Dict()

for animal in animals
    dir_path = joinpath(train_dir, animal)
    sampled_images[animal] = sample_images(dir_path, n_sample)
end

# Maintenant sampled_images["cheetah"] contient 5 images aléatoires de cheetah
