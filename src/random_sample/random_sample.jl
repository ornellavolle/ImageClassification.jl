using Random, Glob, FileIO, Images

# --- Définition d'une structure pour gérer l'échantillonnage d'images ---
mutable struct AnimalSampler
    root::String   # répertoire racine
    animals::Vector{String}   # liste des animaux
end

# --- Méthode utilitaire : obtenir le chemin du dossier d'un animal ---
function get_animal_dir(s::AnimalSampler, animal::String)
    return joinpath(s.root, "data", "train", animal)
end

# --- Échantillonner n images pour UN animal ---
function Base.rand(s::AnimalSampler, animal::String, n::Int)
    animal_dir = get_animal_dir(s, animal)
    all_files = glob("*.jpg", animal_dir)
    if isempty(all_files)
        @warn "Aucune image trouvée pour $animal dans $animal_dir"
        return []
    end
    # s'assurer que n ne dépasse pas le nombre de fichiers disponibles ---
    n = min(n, length(all_files))
    sampled_files = rand(all_files, n)
    return [load(f) for f in sampled_files]
end


# --- Échantillonner n images PAR animal ---
function Base.rand(s::AnimalSampler, n::Int)
    # dictionnaire pour stocker les images
    sampled = Dict{String, Vector{Any}}()
    for animal in s.animals
        # échantillonnage avec min(n, nombre disponible)
        imgs = rand(s, animal, n)
        sampled[animal] = imgs
        println("$animal : $(length(imgs)) images échantillonnées")
    end
    return sampled
end


# --- Échantillonner n images en tout, parmi tous les animaux ---
function rand_all(s::AnimalSampler, n::Int)
    all_paths = []
    # créer la liste de tous les fichiers disponibles avec leur animal
    for animal in s.animals
        animal_dir = get_animal_dir(s, animal)
        files = glob("*.jpg", animal_dir)
        append!(all_paths, [(animal, f) for f in files])
    end
    isempty(all_paths) && error("Aucune image trouvée dans $(s.root_dir)")
    # limiter n si nécessaire
    n = min(n, length(all_paths))
    sampled_pairs = rand(all_paths, n)
    sampled_images = Dict{String, Vector{Any}}()
    for (animal, path) in sampled_pairs
        push!(get!(sampled_images, animal, []), load(path))
    end
    # Affichage du nombre d'images par animal
    for (animal, imgs) in sampled_images
        println("$animal : $(length(imgs)) images échantillonnées")
    end
    return sampled_images
end