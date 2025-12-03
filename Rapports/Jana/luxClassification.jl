
using Lux
using MLUtils: DataLoader
using Images
using FileIO
using Random
using Statistics
using Zygote
using Optimisers
using OneHotArrays: onehotbatch, onecold
using NNlib
using ImageTransformations  
using BSON

#IMAGE LOADING 

function load_images(data_dir; img_size=(64,64))
    classes = filter(x -> isdir(joinpath(data_dir, x)), readdir(data_dir))
    all_images = Vector{Array{Float32,3}}()
    labels = Int[]

    for (class_idx, class_name) in enumerate(sort(classes))
        class_path = joinpath(data_dir, class_name)
        files = readdir(class_path)

        for f in files
            path = joinpath(class_path, f)
            try
                img = load(path)
                img = imresize(RGB.(img), img_size)

                arr = zeros(Float32, img_size[1], img_size[2], 3)
                @inbounds for i in 1:img_size[1], j in 1:img_size[2]
                    px = img[i,j]
                    arr[i,j,1] = px.r
                    arr[i,j,2] = px.g
                    arr[i,j,3] = px.b
                end

                push!(all_images, arr)
                push!(labels, class_idx)
            catch
                continue
            end
        end

        println("✓ Loaded $(class_name)")
    end

    X = cat(all_images..., dims=4)  # H×W×C×N (WHCN)
    return X, labels, sort(classes)
end




#NORMALIZATION


function normalize_train_test(X_train, X_test)
    μ = mean(X_train, dims=(1,2,4))
    σ = std(X_train,  dims=(1,2,4))

    X_train_n = (X_train .- μ) ./ (σ .+ 1f-7)
    X_test_n  = (X_test  .- μ) ./ (σ .+ 1f-7)

    return X_train_n, X_test_n, μ, σ

end




#DATA AUGMENTATION 
######################

function augment_batch(x)
    H, W, C, N = size(x)
    x_aug = similar(x)
    for i in 1:N
        img = @view x[:, :, :, i]

        # random horizontal flip
        if rand() < 0.5
            img = reverse(img, dims=2)
        end

       

        x_aug[:, :, :, i] = img
    end
    return x_aug
end




#MODEL
##########

function create_cnn(num_classes)
    Lux.Chain(
        Lux.Conv((3,3), 3=>32, Lux.relu; pad=1),
        Lux.MaxPool((2,2)),

        Lux.Conv((3,3), 32=>64, Lux.relu; pad=1),
        Lux.MaxPool((2,2)),

        Lux.Conv((3,3), 64=>128, Lux.relu; pad=1),
        Lux.MaxPool((2,2)),

        Lux.FlattenLayer(),
        Lux.Dense(128*8*8, 128, Lux.relu),
        Lux.Dense(128, num_classes)
    )
end



#COMPUTE LOSSS
########################
function compute_loss(model, ps, st, x, y)
    y_pred, st2 = model(x, ps, st)
    logp = NNlib.logsoftmax(y_pred; dims=1)
    loss = -sum(y .* logp) / size(y,2)
    return loss, st2
end



#TRAINING
########################

function train_epoch!(model, ps, st, opt_state, loader)
    total = 0.0
    nb = 0

    for (x,y) in loader
        x = augment_batch(x)  # apply data augmentation only on training batches

        function lossfun(ps)
            compute_loss(model, ps, st, x, y)
        end

        (loss, st2), back = Zygote.pullback(lossfun, ps)
        grads = back((1.0, nothing))[1]

        opt_state, ps = Optimisers.update(opt_state, ps, grads)
        st = st2

        total += loss
        nb += 1
    end

    return total/nb, ps, st, opt_state
end




#EVALUATION 
#####################
function test_accuracy(model, ps, st, X, y_true; nclasses)
    y_pred, _ = model(X, ps, st)
    pred = onecold(y_pred, 1:nclasses)
    truth = onecold(onehotbatch(y_true, 1:nclasses), 1:nclasses)
    return sum(pred .== truth) / length(truth), pred, truth
end

# CF rows = true class and   cols = predicted class
function confusion_matrix(pred, truth; nclasses, class_names)
    cm = zeros(Int, nclasses, nclasses)
    for (t,p) in zip(truth, pred)
        cm[t, p] += 1
    end

    println("\nConfusion matrix (rows = true, cols = pred):")
    print(" " ^ 10)
    for j in 1:nclasses
        print(rpad(class_names[j], 10))
    end
    println()
    for i in 1:nclasses
        print(rpad(class_names[i], 10))
        for j in 1:nclasses
            print(rpad(string(cm[i,j]), 10))
        end
        println()
    end

    return cm
end

# to show  a few sample images with true and predicted labels
function show_sample_predictions(model, ps, st, X, y_true, classes; n=5)
    N = size(X, 4)
    n = min(n, N)
    idxs = rand(1:N, n)

    y_pred, _ = model(X, ps, st)
    pred_labels = onecold(y_pred, 1:length(classes))

    println("\nSample predictions:")
    for k in idxs
        t = y_true[k]
        p = pred_labels[k]
        println("Sample $k → true = $(classes[t]), predicted = $(classes[p])")

        #display the imag
        img = X[:, :, :, k]
        img_clip = clamp.(img, 0f0, 1f0)
        img_rgb = colorview(RGB, permutedims(img_clip, (3,1,2)))  # C×H×W → RGB image
        display(img_rgb)
    end
end



#Main
########

function main()
    println("Loading training data…")
    X_train, y_train, classes = load_images("data/train")

    println("Loading validation data…")
    X_test,  y_test,  _ = load_images("data/validation")

    X_train, X_test, μ, σ = normalize_train_test(X_train, X_test)


    y_train_oh = onehotbatch(y_train, 1:length(classes))

    train_loader = DataLoader((X_train, y_train_oh); batchsize=16, shuffle=true)

    rng = Random.default_rng()
    Random.seed!(rng, 42)

    model = create_cnn(length(classes))
    ps, st = Lux.setup(rng, model)
    opt_state = Optimisers.setup(Optimisers.Adam(1e-3), ps)

    println("\n===== TRAINING =====")
    best_acc = 0.0
    best_ps = ps
    best_st = st

    for epoch in 1:10
        loss, ps, st, opt_state = train_epoch!(model, ps, st, opt_state, train_loader)
        acc, _, _ = test_accuracy(model, ps, st, X_test, y_test; nclasses=length(classes))

        if acc > best_acc
            best_acc = acc
            best_ps = ps
            best_st = st
        end

        println("Epoch $epoch | Loss=$(round(loss, digits=4)) | Acc=$(round(acc*100, digits=1))%")
    end

    println("\nBest accuracy: $(round(best_acc*100, digits=2))%")

    acc, pred, truth = test_accuracy(model, best_ps, best_st, X_test, y_test; nclasses=length(classes))
    cm = confusion_matrix(pred, truth; nclasses=length(classes), class_names=classes)
    show_sample_predictions(model, best_ps, best_st, X_test, y_test, classes; n=5)
    
    # Save model 
    BSON.@save "modelLux.bson" model best_ps best_st classes μ σ

    println("Model saved to modelLux.bson")

    return best_ps, best_st, model, classes, μ, σ, cm

end

ps, st, model, classes, μ, σ, cm = main();
