# New Book

```julia (editor=true, logging=false, output=true)
using MLJ, Flux, MLJFlux
import RDatasets
import Optimisers

# 1. Load Data
iris = RDatasets.dataset("datasets", "iris");
y, X = unpack(iris, ==(:Species), colname -> true, rng=123);
