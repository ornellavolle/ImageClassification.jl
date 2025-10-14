# Real Fitting a line

```julia (editor=true, logging=false, output=true)
using Flux
```
```julia (editor=true, logging=false, output=true)
actual(x) = 4x + 2
x_train, x_test = hcat(0:5...), hcat(6:10...)
y_train, y_test = actual.(x_train), actual.(x_test)
```
```julia (editor=true, logging=false, output=true)
length(x_train)
print(x_train)

length(y_train)
y_train
```
