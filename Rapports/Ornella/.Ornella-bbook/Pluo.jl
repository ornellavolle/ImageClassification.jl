using Markdown
using InteractiveUtils
using Pkg

#Pkg.activate("Project.toml")
#Pkg.add("Flux")

#load data pour les hyénes
#il faut dormaliser nos données pour qu'on puisse les mettre sous la même taille
#trainData = Flux.DataLoader((X, Y), batchsize=32)
trainData = "data/cheetah_train_resized"
testData  = "data/cheetah_validation_resized"

length(trainData)

imwrite(rand(Uint8,300,300,3),"cheetah_000_resized.jpg")