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
images[575]

#recipe for building the neural network
import MLJFlux
struct MyConvBuilder
    filter_size::Int
    channels1::Int
    channels2::Int
    channels3::Int
end

function MLJFlux.build(b::MyConvBuilder, rng, n_in, n_out, n_channels)
    k, c1, c2, c3 = b.filter_size, b.channels1, b.channels2, b.channels3
    mod(k, 2) == 1 || error("`filter_size` must be odd. ")
    p = div(k - 1, 2) # padding to preserve image size
    init = Flux.glorot_uniform(rng)
    front = Chain(
        Conv((k, k), n_channels => c1, pad=(p, p), relu, init=init),
        MaxPool((2, 2)),
        Conv((k, k), c1 => c2, pad=(p, p), relu, init=init),
        MaxPool((2, 2)),
        Conv((k, k), c2 => c3, pad=(p, p), relu, init=init),
        MaxPool((2 ,2)),
        MLUtils.flatten)
    d = Flux.outputsize(front, (n_in..., n_channels, 1)) |> first
    return Chain(front, Dense(d, n_out, init=init))
end

#We now define the MLJ model.
ImageClassifier = @load ImageClassifier
clf = ImageClassifier(
    builder=MyConvBuilder(3, 16, 32, 32),
    batch_size=50,
    epochs=10,
    rng=123,
)

ImageClassifier(
  builder = Main.MyConvBuilder(3, 16, 32, 32), 
  finaliser = NNlib.softmax, 
  optimiser = Adam(eta=0.001, beta=(0.9, 0.999), epsilon=1.0e-8), 
  loss = Flux.Losses.crossentropy, 
  epochs = 10, 
  batch_size = 50, 
  lambda = 0.0, 
  alpha = 0.0, 
  rng = 123, 
  optimiser_changes_trigger_retraining = false, 
  acceleration = CPU1{Nothing}(nothing))


#For illustration purposes, we won't use all the data here:
  train = 1:500
test = 501:1000

#Binding the model with data in an MLJ machine:
mach = machine(clf, images, labels);

#Training for 10 epochs on the first 500 images:
fit!(mach, rows=train, verbosity=2);

#Inspecting:
report(mach)

chain = fitted_params(mach)

Flux.params(chain)[2]

#Adding 20 more epochs:
clf.epochs = clf.epochs + 20
fit!(mach, rows=train);

#Computing an out-of-sample estimate of the loss:
predicted_labels = predict(mach, rows=test);
cross_entropy(predicted_labels, labels[test])

#Or to fit and predict, in one line:
evaluate!(mach,
          resampling=Holdout(fraction_train=0.5),
          measure=cross_entropy,
          rows=1:1000,
          verbosity=0)

#To extract Flux params from an MLJFlux machine
parameters(mach) = vec.(Flux.params(fitted_params(mach)));

#To store the traces:
losses = []
training_losses = []
parameter_means = Float32[];
epochs = []

#To update the traces:

update_loss(loss) = push!(losses, loss)
update_training_loss(losses) = push!(training_losses, losses[end])
update_means(mach) = append!(parameter_means, mean.(parameters(mach)));
update_epochs(epoch) = push!(epochs, epoch)

#The controls to apply:
save_control =
    MLJIteration.skip(Save(joinpath(tempdir(), "mnist.jls")), predicate=3)

controls=[
    Step(2),
    Patience(3),
    InvalidValue(),
    TimeLimit(5/60),
    save_control,
    WithLossDo(),
    WithLossDo(update_loss),
    WithTrainingLossesDo(update_training_loss),
    Callback(update_means),
    WithIterationsDo(update_epochs),
];

#The "self-iterating" classifier:

iterated_clf = IteratedModel(
    clf,
    controls=controls,
    resampling=Holdout(fraction_train=0.7),
    measure=log_loss,
)


#Binding the wrapped model to data:
mach = machine(iterated_clf, images, labels);

#Training
fit!(mach, rows=train);

#Comparison of the training and out-of-sample losses:
plot(
    epochs,
    losses,
    xlab = "epoch",
    ylab = "cross entropy",
    label="out-of-sample",
)
plot!(epochs, training_losses, label="training")

savefig(joinpath(tempdir(), "loss.png"))

#Evolution of weights
n_epochs =  length(losses)
n_parameters = div(length(parameter_means), n_epochs)
parameter_means2 = reshape(copy(parameter_means), n_parameters, n_epochs)'
plot(
    epochs,
    parameter_means2,
    title="Flux parameter mean weights",
    xlab = "epoch",
)


savefig(joinpath(tempdir(), "weights.png"))

#Retrieving a snapshot for a prediction:
mach2 = machine(joinpath(tempdir(), "mnist3.jls"))
predict_mode(mach2, images[500:508])

#Restarting training
#Mutating iterated_clf.controls or clf.epochs (which is otherwise ignored) will allow you to restart training from where it left off.

iterated_clf.controls[2] = Patience(4)
fit!(mach, rows=train)

plot(
    epochs,
    losses,
    xlab = "epoch",
    ylab = "cross entropy",
    label="out-of-sample",
)
plot!(epochs, training_losses, label="training")