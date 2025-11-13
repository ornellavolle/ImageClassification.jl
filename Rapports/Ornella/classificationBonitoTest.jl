using GLMakie
using FileIO, Glob
using GLMakie: Button, Slider, Label, image!
using ImageClassification



load_dataset()

# --- App GLMakie ---
App() do app
    # Observable pour l'image courante
    current_index = Observable(1)
    current_img = Observable(load(images[current_index[]]))

    # Figure principale
    fig = Figure(parent = app, size = (900, 700))

    # Zone image
    ax = Axis(fig[1, 1]; title = "Classification d’images")
    img_plot = image!(ax, current_img[])
    hidedecorations!(ax)
    autolimits!(ax)

    # Boutons précédent / suivant
    prev_btn = Button(fig[2, 1], label = "Précédent")
    next_btn = Button(fig[2, 2], label = "Suivant")

    # Slider
    slider = Slider(fig[3, 1:2], range = 1:length(images), startvalue = 1)

    # Label
    label = Label(fig[4, 1:2], text = "Image 1 / $(length(images))", tellwidth = false)

    # --- Fonction pour mettre à jour l'image ---
    function update_image(index)
        current_index[] = index
        current_img[] = load(images[index])
        img_plot[1][] = current_img[]
        slider.value[] = index
        label.text = "Image $index / $(length(images))"
    end

    # Callbacks
    on(slider.value) do val
        update_image(round(Int, val))
    end

    on(prev_btn.clicks) do _
        update_image(max(1, current_index[] - 1))
    end

    on(next_btn.clicks) do _
        update_image(min(length(images), current_index[] + 1))
    end

    display(fig)
end
