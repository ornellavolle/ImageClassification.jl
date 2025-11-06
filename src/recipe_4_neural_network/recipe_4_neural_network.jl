# --- Définition du constructeur ---
struct MyConvBuilder
    filter_size::Int      # taille des filtres de convolution (ex: 3)
    channels1::Int        # nombre de canaux dans le 1er bloc conv
    channels2::Int
    channels3::Int
end

function MLJFlux.build(b::MyConvBuilder, rng, image_size, n_out, n_channels)
    # image_size = (height, width)
    k, c1, c2, c3 = b.filter_size, b.channels1, b.channels2, b.channels3
    mod(k, 2) == 1 || error("`filter_size` must be odd.")
    p = div(k - 1, 2)  # padding pour garder même taille après conv
    init = Flux.glorot_uniform(rng)

    front = Chain(
        Conv((k, k), n_channels => c1, pad=(p, p), relu, init=init),
        MaxPool((2, 2)),
        Conv((k, k), c1 => c2, pad=(p, p), relu, init=init),
        MaxPool((2, 2)),
        Conv((k, k), c2 => c3, pad=(p, p), relu, init=init),
        MaxPool((2, 2)),
        MLUtils.flatten
    )

    # Taille de sortie du CNN avant la couche fully connected
    d = Flux.outputsize(front, (image_size..., n_channels, 1)) |> first

    # Réseau complet
    return Chain(front, Dense(d, n_out, init=init))
end