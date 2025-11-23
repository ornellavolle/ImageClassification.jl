using Lux
using BSON
using Images
using ImageTransformations
using OneHotArrays
using NNlib


function load_lux_model(path::String)
    data = BSON.load(path)
    model   = data[:model]
    ps      = data[:best_ps]
    st      = data[:best_st]
    classes = data[:classes]
    μ       = data[:μ]
    σ       = data[:σ]
    return model, ps, st, classes, μ, σ
end


#resize, normalize, and convert the image the same way as in the training
function preprocess_lux_image(img, μ, σ; img_size=(64,64))
    img_resized = imresize(RGB.(img), img_size)

    arr = zeros(Float32, img_size[1], img_size[2], 3, 1)

    @inbounds for i in 1:img_size[1], j in 1:img_size[2]
        px = img_resized[i,j]
        arr[i,j,1,1] = px.r
        arr[i,j,2,1] = px.g
        arr[i,j,3,1] = px.b
    end

    # SAME NORMALIZATION AS TRAINING
    arr = (arr .- μ) ./ (σ .+ 1f-7)

    return arr
end


#predicting the image
function predict_lux_class(model, ps, st, X, classes)
    y_pred, _ = model(X, ps, st)
    idx = onecold(y_pred, 1:length(classes))
    return classes[idx]
end


# gives the probability for each class, the probability that this image belongs to this particular class by the model
function predict_lux_probabilities(model, ps, st, X)
    y_pred, _ = model(X, ps, st)
    prob = NNlib.softmax(y_pred; dims=1)
    return vec(prob)
end
