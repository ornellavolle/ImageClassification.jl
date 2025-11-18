########## Tests des struct/ Multiple Dispaching  ##########

# Liste de 20 animaux avec leurs attributs
animals = [
    Cheetah("Chester", 60, 110),
    Cheetah("Flash", 55, 115),
    Cheetah("Speedy", 50, 120),
    Cheetah("Dart", 58, 105),
    Cheetah("Bolt", 62, 108),

    Hyena("Shenzi", true, 35),
    Hyena("Banzai", true, 40),
    Hyena("Ed", true, 30),
    Hyena("Nala", false, 25),
    Hyena("Zuri", true, 28),

    Jaguar("Rio", false, "Très puissante"),
    Jaguar("Shadow", true, "Extrêmement puissante"),
    Jaguar("Tigreto", true, "Puissante"),
    Jaguar("Onça", true, "Très puissante"),
    Jaguar("Puma", true, "Puissante"),

    Tiger("Khan", 10, true, 1400),
    Tiger("Rajah", 8, true, 1600),
    Tiger("Siber", 22, true, 1800),
    Tiger("Stripes", 5, true, 1550),
    Tiger("Sheru", 3, true, 1500)
]

# afficher un animal : 
animals[17]

# afficher chaque élément du vecteur : 
animals

