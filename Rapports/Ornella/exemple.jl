import WGLMakie
import Makie
# ======== CHEMINS ========
base_path = "/Users/admin/Desktop/MIASHS/MasterM1SSD/CoursRJulia/GitHub_package/ImageClassification.jl/data"

train_path = joinpath(base_path, "train")
val_path   = joinpath(base_path, "validation")

# ======== CHARGEMENT DU DATASET ========
train_images, train_labels = load_dataset(dataset="train")
val_images,   val_labels   = load_dataset(dataset="validation")

println("Train set: $(length(train_images)) images")
println("Validation set: $(length(val_images)) images")

# ======== MLJ : conversion types ========
train_labels = coerce(train_labels, Multiclass)
val_labels   = coerce(val_labels, Multiclass)

# Vérification MLJ
@assert scitype(train_images) <: AbstractVector{<:Image}
@assert scitype(train_labels) <: AbstractVector{<:Finite}

# Pour tester une image :
display(train_images[2520])


# ============================================================
#  INTERFACE GRAPHIQUE WGLMAKIE AVEC IMAGES DU DATASET
# ============================================================

WGLMakie.activate!()

function interface_images(images)

    fig = Figure(size = (900, 650))

    # Zone d'affichage
    ax = Axis(fig[1, 1])
    hidexdecorations!(ax)
    hideydecorations!(ax)

    # Observable index
    current_index = Observable(1)

    # image affichée (Observable)
    image_obs = Observable(images[1])
    image!(ax, image_obs)

    # Mise à jour quand on change l'index
    on(current_index) do idx
        image_obs[] = images[idx]
    end

    # Bouton "Précédent"
    btn_prev = Button(fig[2, 1], label = " Précédent")
    on(btn_prev.clicks) do _
        current_index[] = max(1, current_index[] - 1)
    end

    # Bouton "Suivant"
    btn_next = Button(fig[2, 2], label = "Suivant ")
    on(btn_next.clicks) do _
        current_index[] = min(length(images), current_index[] + 1)
    end

    # Slider
    slider = Slider(fig[3, 1:2], range = 1:length(images), startvalue = 1)

    # Slider → index
    on(slider.value) do v
        current_index[] = Int(v)
    end

    # Index → slider
    on(current_index) do idx
        slider.value[] = idx
    end

    display(fig)
end

# ============================================================
#  LANCEMENT SUR LE DATASET TRAIN
# ============================================================

interface_images(train_images)
