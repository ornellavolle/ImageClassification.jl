using WGLMakie
using Makie
using GLMakie
using ImageClssification

WGLMakie.activate!()

function interface_images()
    fig = Figure(size = (900, 650))

    # Zone d'affichage
    ax = Makie.Axis(fig[1, 1])
    hidexdecorations!(ax)
    hideydecorations!(ax)

    # Images factices
    images = [rand(RGBf, 400, 400) for _ in 1:5]

    # Observable pour l'index
    current_index = Observable(1)

    # Observable pour l'image courante
    image_obs = Observable(images[1])
    image!(ax, image_obs)

    # Mise à jour de l'image quand l'index change
    on(current_index) do idx
        image_obs[] = images[idx]
    end

    # --- Bouton précédent ---
    btn_prev = Button(fig[2, 1], label = "⬅️ Précédent")
    on(btn_prev.clicks) do _
        current_index[] = max(1, current_index[] - 1)
    end

    # --- Bouton suivant ---
    btn_next = Button(fig[2, 2], label = "Suivant ➡️")
    on(btn_next.clicks) do _
        current_index[] = min(length(images), current_index[] + 1)
    end

    # --- Slider ---
    slider = Slider(fig[3, 1:2], range = 1:length(images), startvalue = 1)

    # Slider → index
    on(slider.value) do v
        current_index[] = Int(v)
    end

    # Index → slider (pour garder la synchro)
    on(current_index) do idx
        slider.value[] = idx
    end

    display(fig)
end

interface_images()
