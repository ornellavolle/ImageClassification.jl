using ImageClassification

########## Tests des fonctions pour lire/redimensionner des images ##########

# exemple d'utilisation de la fonction load_image :
load_image(joinpath("cheetah","cheetah_000_resized.jpg"))

# exemple, importation toute les données de train : 
load_dataset()

# exemple, import par dossier : 
load_dataset(dataset="validation")
