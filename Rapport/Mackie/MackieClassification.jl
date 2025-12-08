import WGLMakie
import Makie
using ImageClassification

base_path = "/Users/admin/Desktop/MIASHS/MasterM1SSD/CoursRJulia/GitHub_package/ImageClassification.jl/data"

train_images, train_labels = load_dataset(dataset="train", size = (600,600))
val_images, val_labels  = load_dataset(dataset="validation", size = (600,600))

println("Train set: $(length(train_images)) images")
println("Validation set: $(length(val_images)) images")

# Aprés l'importation des images on va faire notre interface graphique 
WGLMakie.activate!()
function interface_images(images)
    
    fig = Makie.Figure(size = (600, 600))

    ax = Makie.Axis(fig[1, 1], aspect = Makie.DataAspect())  # Taille NORMALISÉE

    Makie.hidexdecorations!(ax)
    Makie.hideydecorations!(ax)

    # Observable index
    current_index = Makie.Observable(1)

    # Correction orientation : WGLMakie inverse l'axe vertical.
    fix_orientation(img) = Makie.rotr90(img, 1)

    # Image affichée
    image_obs = Makie.Observable( fix_orientation(images[1]) )
    Makie.image!(ax, image_obs)

    # Mise à jour quand l’index change
    Makie.on(current_index) do idx
        image_obs[] = fix_orientation(images[idx])
    end

  # pour le bouton précédent
    btn_prev = Makie.Button(fig[2, 1], label = " Précédent")
    Makie.on(btn_prev.clicks) do _
        current_index[] = max(1, current_index[] - 1)
        println("Image précédente -> index : ", current_index[])
    end
    #on fait du mackie mais c'est okay car on peut tout de même 

    # pour le bouton suivant
    btn_next = Makie.Button(fig[2, 2], label = "Suivant ")
    Makie.on(btn_next.clicks) do _
        current_index[] = min(length(images), current_index[] + 1)
        println("Image suivante -> index : ", current_index[])
    end

    slider = Makie.Slider(fig[3, 1:2], range = 1:length(images), startvalue = 1)
    updating = Makie.Observable(false)
       # Slider -> index
Makie.on(slider.value) do v
    #c'est une boucle qui nous permet de faire une image puis de regarder la suivante
    if !updating[]
        updating[] = true
        current_index[] = Int(v)
        updating[] = false
    end
end

# Index -> slider
Makie.on(current_index) do idx
    if !updating[]
        updating[] = true
        slider.value[] = idx
        updating[] = false
    end
end
 
    Makie.display(fig)
end

interface_images(train_images)
#Warning: detected a stack overflow; program state may be corrupted, so further execution might be unreliable