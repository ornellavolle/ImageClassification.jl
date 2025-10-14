# New Book

```julia (editor=true, logging=false, output=true)
using MLJ, Flux, MLJFlux
import RDatasets
import Optimisers

# 1. Load Data
iris = RDatasets.dataset("datasets", "iris");
y, X = unpack(iris, ==(:Species), colname -> true, rng=123);

# 2. Load and instantiate model
NeuralNetworkClassifier = @load NeuralNetworkClassifier pkg="MLJFlux"
clf = NeuralNetworkClassifier(
    builder=MLJFlux.MLP(; hidden=(5,4), σ=Flux.relu),
    optimiser=Optimisers.Adam(0.01),
    batch_size=8,
    epochs=100,
    acceleration=CUDALibs()         # For GPU support
    )

# 3. Wrap it in a machine
mach = machine(clf, X, y)

# 4. Evaluate the model
cv=CV(nfolds=5)
evaluate!(mach, resampling=cv, measure=accuracy)
```
