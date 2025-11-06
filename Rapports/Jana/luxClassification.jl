using Lux,
    ComponentArrays,
    SciMLSensitivity,
    LuxCUDA,
    Optimisers,
    OrdinaryDiffEqTsit5,
    Random,
    Statistics,
    Zygote,
    OneHotArrays,
    InteractiveUtils,
    Printf
using MLUtils: DataLoader, splitobs
using Images, ImageIO, ImageTransformations, FilePathsBase

CUDA.allowscalar(false)

#=

function load_animals(batchsize::Int, train_split::Float64)
    classes = ["cheetah", "hyena", "jaguar", "tiger"]
    n_classes = length(classes)
    img_size = (64,64)

    function load_folder(base_dir::String)
        X, Y = [], Int[]
        for (label, cls) in enumerate(classes)
            for img_path in readdir(joinpath(base_dir, cls); join=true)
                img = load(img_path)
                img = imresize(img, img_size)
                img = Float32.(channelview(img)) ./ 255
                push!(X, img)
                push!(Y, label)
            end
        end
        return cat(X..., dims=4), onehotbatch(Y, 1:n_classes)
    end

    train_dir = "data/train"
    val_dir = "data/validation"

    x_train, y_train = load_folder(train_dir)
    x_val, y_val = load_folder(val_dir)

    return (
        DataLoader((x_train, y_train); batchsize, shuffle=true),
        DataLoader((x_val, y_val); batchsize, shuffle=false),
    )
end


=#