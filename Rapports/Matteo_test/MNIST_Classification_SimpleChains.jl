using MLJ
using Flux
import MLJFlux
import MLUtils
import MLJIteration # for `skip`

using Plots
gr(size=(600, 300*(sqrt(5)-1)));

####Basic training####

#Downloading the MNIST image dataset:
import MLDatasets: MNIST

ENV["DATADEPS_ALWAYS_ACCEPT"] = true
images, labels = MNIST(split=:train)[:];

#On force les labels à avoir le Multiclass scientific type
labels = coerce(labels, Multiclass);
images = coerce(images, GrayImage);

#On vérifie si on a bien mis le scientific type
#@assert scitype(images) <: AbstractVector{<:Image}
#@assert scitype(labels) <: AbstractVector{<:Finite}
#je comprends pas bien ce qui a été fait ici

typeof(labels)
typeof(labels)

scitype(labels)

#Affichage d'une image du dataset MNIST
images[135]










