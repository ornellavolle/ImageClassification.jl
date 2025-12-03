using ImageClassification

crier(::Cerf) = "Bramer"
crier(::Loup) = "Hurler"

c=Cerf(180.0)

crier(c)

l=Loup("cheval")
crier(l)

subtypes(Animal)
subtypes(Carnivore)