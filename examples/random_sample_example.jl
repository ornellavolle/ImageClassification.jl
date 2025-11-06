using ImageClassification

########## Tests de l'échantillonage d'animaux ##########

# Définition du répertoire et de la liste d'animaux :
root = pwd() 
animals = ["cheetah", "hyena", "tiger", "jaguar"]

# Création du struct :
sampler = AnimalSampler(root, animals)

# avoir le chemin du dossier d'un animal : 
get_animal_dir(sampler, "cheetah")

# Tirer 5 images d'un cheetah :

rand_one_animal(sampler,"cheetah",5)

# Tirer 8 images pour chaque animal :
sampled_by_animal = rand_each_animal(sampler, 8)

# Tirer 20 images au total, réparties entre tous les animaux :
sampled_global = rand_all(sampler, 20)

