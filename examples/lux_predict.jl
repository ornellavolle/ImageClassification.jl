using ImageClassification

using FileIO

# load the already trained model
model, ps, st, classes, μ, σ = load_lux_model("modelLux.bson"); nothing

# load the image to classify it
img = load("data/validation/cheetah/cheetah_032_val_resized.jpg")


# Convert it to Lux format
X = preprocess_lux_image(img, μ, σ)  

# predict it
label = predict_lux_class(model, ps, st, X, classes)
println("Predicted class: ", label)

# print class probabilities
probs = predict_lux_probabilities(model, ps, st, X)
println("Probabilities: ", probs)
