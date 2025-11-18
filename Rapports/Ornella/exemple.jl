using WGLMakie, Images

# Active GLMakie pour l'affichage
GLMakie.activate!()

# Fonction pour créer l'interface
function interface_images()
    # Crée une fenêtre Makie
    fig = Figure(size = (800, 600))

    # Zone pour afficher l'image
    ax = GLMakie.Axis(fig[1, 1])
    hidexdecorations!(ax)
    hideydecorations!(ax)

    # Génère des images aléatoires pour l'exemple
    images = [rand(RGB, 400, 400) for _ in 1:5]  # 5 images aléatoires
    current_index = Observable(1)  # Index de l'image actuelle

    # Affiche l'image actuelleusin
    image_obs = @lift(images[$current_index])
    image!(ax, image_obs)

    # Boutons "Précédent" et "Suivant"
    btn_prev = Button(fig[2, 1], label = "Précédent")
    btn_next = Button(fig[2, 2], label = "Suivant")

    # Logique des boutons
    on(btn_prev.clicks) do _
        current_index[] = max(1, current_index[] - 1)
        @info "Bouton Précédent cliqué - Index: $(current_index[])"
    end

    on(btn_next.clicks) do _
        current_index[] = min(length(images), current_index[] + 1)
        @info "Bouton Suivant cliqué - Index: $(current_index[])"
    end

    # Ajoute un slider pour naviguer entre les images
    slider = Slider(fig[3, 1:2], range = 1:length(images), startvalue = 1)
    on(slider.value) do val
        current_index[] = val
        @info "Slider déplacé - Index: $val"
    end

    # Affichage de la fenêtre
    display(fig)
end

# Lance l'interface
interface_images()
