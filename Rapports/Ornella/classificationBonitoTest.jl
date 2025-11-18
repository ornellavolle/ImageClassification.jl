using GLMakie

# Active GLMakie pour l'affichage
GLMakie.activate!()

# Crée une fenêtre
fig = Figure(size = (400, 200))

# Ajoute deux boutons
btn_prev = Button(fig[1, 1], label = "Précédent")
btn_next = Button(fig[1, 2], label = "Suivant")

# Logique des boutons (affiche un message dans la console)
on(btn_prev.clicks) do _
    println("Bouton Précédent à était bien cliqué")
end

on(btn_next.clicks) do _
    println("Bouton Suivant à était bien cliqué")
end

# Affiche la fenêtre
display(fig)
