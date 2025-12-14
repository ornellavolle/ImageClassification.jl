# Rapport Projet Julia

**Jana Al Jamal**   **Anna Cochat**   **Matteo Schweizer**   **Ornella Volle**

*M1 SSD – Université Grenoble Alpes*  

**Année 2025–2026**

## Introduction

Dans le cadre de notre projet julia nous avons déterminé comme objectif de base la classification d’images. Nous voulions créer notre propre méthode de classification en utilisant les réseaux de neurones (CNN) mais par manque de temps nous avons décidé de faire plusieurs exercices, par exemple de la métaprogramation, du multipledispaching, et de la classification (package Flux et par lux) dont le centre était une classification des animaux (cheetah, tigre, hyene et jaguar). Pour avoir une représentation graphique de ce que nous faisions, nous avons décidé de créer une application interactive sous R (Rshiny) et sous Julia (Bonito).  


## Le package :

Pour organiser l’ensemble de notre code et le rendre réutilisable, nous avons décidé de créer un package Julia nommé ImageClassification.

Dans le fichier ImageClassification.jl, nous avons créé le module principal :

```julia
module ImageClassification

# Exports : rendre certaines fonctions et types accessibles depuis l’extérieur
export load_image, load_dataset
export Cheetah, Hyena, Jaguar, Tiger
export interact
export ⊔
export AnimalSampler, get_animal_dir
export rand, rand_all
export describe, random_value, make_random_animal
# ... etc.

# Inclusion des sous-fichiers
include("recipe_4_neural_network/recipe_4_neural_network.jl")
include("type_creation/type_creation.jl")
include("load/load.jl")
include("multiple_dispaching/animals.jl")
include("multiple_dispaching/interactions.jl")
include("multiple_dispaching/operareur.jl")
include("random_sample/random_sample.jl")
include("metaprogrammation/metaprogramming.jl")
include("classificationLux/classification_lux.jl")

end
```

  * module ImageClassification ... end définit l’espace de noms.
  * export ... liste toutes les fonctions et types que nous souhaitons rendre accessibles aux utilisateurs du package.
  * include("chemin/vers/fichier.jl") permet d’intégrer des scripts externes à l’intérieur du module.

Une fois le package défini, nous pouvons l’utiliser dans n’importe quel script Julia à l'aide de la commande suivante à inclure au début du script :

```julia
using ImageClassification
```

Grâce aux export dans la package, toutes les fonctions et types listés sont accessibles directement juste en les appelants.


## Le dataset : 

Pour faire la classification d’images, nous avons récupéré sur Kaggle un jeu de données contenant 4000 images de 4 espèces animales différentes: des images de jaguars, des images de guépards, des images de hyènes et des images de tigres. Dans ce jeu de données, nous avons 2 dossiers: un dossier train et un dossier validation. Le dossier train contient un total de 3600 images réparties dans 4 sous-dossiers “espèce” de 900 photos (un sous-dossier “espèce” possède les photos pour une espèce). Le dossier validation est organisé de la même manière mais contient un total de 400 images et chaque sous-dossier “espèce” contient 100 images.


## Classification d'images :

Dans le cadre du projet Julia, nous nous sommes intéressés à la classification d’images. Pour se faire, nous avons utilisé 2 packages Julia faisant de la classification d’image les packages Lux et Flux. Le but d’utiliser 2 packages différent étant de pouvoir bien comprendre comment se déroule une classification d’images à l’aide d’un réseau de neurone et pouvoir comparer leurs fonctionnements.

## La classification Lux

Nous avons travaillé sur la classification d’images avec Lux. Le but était d’entraîner un réseau de neurones convolutionnel qui peut reconnaitre automatiquement les 4 animaux : cheetah, tiger, jaguar et hyena. L’objectif était de comprendre comment on construit un modèle Lux: chargement des images, préparation des données, création du modèle, entraînement, évaluation et prédiction.

Nous avons donc appris comment mettre les images au bon format, normaliser les pixels, définir un CNN avec plusieurs couches convolution, puis entraîner le modèle avec une boucle de training. Nous avons aussi ajouté des fonctions pour tester l’accuracy, afficher des prédictions et sauvegarder le modèle pour le réutiliser plus tard. Ça m’a permis de comprendre vraiment comment fonctionne Lux 

Lux n’a pas de fonction pour entraîner un modèle Au début c’était un peu difficile, et plus de travail, mais en même temps ça nous a aidé a comprendre vraiment comment un réseau de neurones apprend, puisque il n’y a pas de train prêt, je dois construire le training étape par étape (la normalisation, data augemntation,compute_loss,etc)

```julia
function load_images(data_dir; img_size=(64,64))
```

Cette fonction prend toutes les images du dossier et les met dans le bon format pour Lux. Elle regarde les sous dossiers (cheetah, tiger, etc), puis pour chaque image elle la charge, la redimensionne en 64×64 et la transforme en array Float32 avec les trois RGB. À chaque image ajoutée, nous ajoutons aussi son label (le numéro de la classe),par exemple cheetah = 1, hyena = 2, jaguar =3 tiger = 4. Ce numéro est le label de l’image car les modeles no prend pas des mots

Lux a besoin que les images soient dans ce format pour les envoyer dans le réseau de neurones. C’est pour ça que la fonction load_images construit un array en format HWCN (hauteur, largeur, canaux, nombre d’images).

C’est la préparation du dataset avant l’entraînement.

### 2. Normalisation et augmentation

La fonction normalize*train*test sert à mettre toutes les images à la même échelle.Ça aide le modèle à apprendre plus vite

La fonction augment_batch prend un batch d’images et fait un flip horizontal, ca permet d’ajouter  de variété dans les images et d’éviter que le modèle s’habitue trop a un seul type.

### 3. Le modèle Lux

La fonction create_cnn construit le modèle que j’utilise pour la classification. C’est un petit CNN classique : il a trois couches convolution pour extraire les formes dans l’image, chacune suivie d’un maxpool pour réduire la taille. MaxPool, ca réduit la taille de l’image tout en gardant les informations les plus importantes

Ensuite, nous avons défini la loss et la fonction de training.

### 4. L’entraînement du modèle

La fonction compute*loss calcule l’erreur du modèle. Elle prend les prédictions du modèle (y*pred) et les compare aux vraies classes (y). Le résultat est un nombre appelé “loss” plus il est petit, plus le modèle fonctionne bien.

La fonction train_epoch! entraîne le modèle pendant un epoch (un passage complet sur toutes les images). Nous avons entraîné le modèle pendant 10 epochs À chaque epoch, nous affichions la loss et l’accuracy 

### 5. Évaluation et matrice de confusion

Cette partie sert à mesurer si le modèle a bien appris Pour évaluer le modèle, nous avons fait une fonction d’accuracy et une matrice de confusion : montre pour chaque classe combien d’images ont été bien ou mal classée

```julia
function test_accuracy(model, ps, st, X, y_true; nclasses)
    y_pred, _ = model(X, ps, st)
    pred = onecold(y_pred, 1:nclasses)
    truth = onecold(onehotbatch(y_true, 1:nclasses), 1:nclasses)
    return sum(pred .== truth) / length(truth), pred, truth
end
```

### 6. Fonction main et sauvegarde du modele

La fonction main fait toutes les étapes du projet Lux. Elle charge les images de train et validation, les normalise, prépare le DataLoader et crée le modèle CNN. Ensuite elle entraîne le modèle pendant 10 epochs, en affichant la loss et l’accuracy. Elle garde aussi la meilleure version du modèle pendant l'entraînement.

Après l’entraînement, elle calcule l’accuracy finale, affiche la matrice de confusion, et montre quelques prédictions. Puis elle sauvegarde tout dans un fichier .bson.

Nous avons ensuitr sauvegardé le modèle parce que l’entraînement prend longtemps (presque 2h). Donc sauvegarder le modèle évite de devoir tout réentraîner quand nous voulons juste tester ou prédire une image. Nous pouvons juste charger le fichier .bson et utiliser le modèle directement.

Nous avons aussi un fichier séparé qui s’appelle classification_lux.jl. Ce fichier n’entraîne pas le modèle : il sert seulement à charger le modèle déjà entraîné et à faire des prédictions sur de nouvelles images. Glkobalement, dans le package luxClassification.jl, l'ensemble du travail "lourd" est réalisé (charger les données, entraîner pendant 2 heures, choisir le meilleur modèle, etc). Une fois que le modèle est prêt, il est sauvegardé dans modelLux.bson.

Dans classification_lux.jl, nous faisons l’inverse : récupération du modèle déjà entraîné en chargeant ce fichier .bson. Ça évite complètement de relancer l’entraînement, ce qui serait trop long. le modèle est prêt en peu de temps.

Il contient  les fonctions utiles pour charger le modèle déjà entraîné et pour préparer les images avant la prédiction

```julia
function load_lux_model()
```

pour charger le modèle sauvegardé

```julia
function preprocess_lux_image()
```

pour mettre une nouvelle image dans le même format que pendant l’entraînement

```julia
function predict_lux_class
```

renvoie le nom de l’animal

```julia
function predict_lux_probabilities()
```

renvoie les probabilités pour chaque classe

Donc ici, pas d'apprentissage du modèle, utilisation. On prends une image, on la prépare, on la passe dans le modèle, et on obtiens directement la classe prédite

On ne lance pas ces fonctions directement dans ce fichier. Elles sont utilisées dans lux_predict.jl, qui est le script où on fais la prédiction d’une image

Pendant l’entraînement, l’accuracy a commencé à environ 62%, puis elle a augmenté petit à petit au fil des epochs. À partir de l’epoch 3 elle dépasse déjà 77%, et elle continue à monter jusque vers 87–88%. La meilleure accuracy obtenue est 87.75%, ce qui montre que le modèle apprend vraiment à reconnaître les quatre animaux

La matrice de confusion montre que le modèle reconnait surtout très bien tiger (92 bonnes prédictions) et hyena (89 bonnes prédictions). Pour cheetah et jaguar, il fait un peu plus d’erreurs, mais il garde quand même un bon nombre de prédictions correctes. Donc globalement, le modèle arrive à distinguer les 4 animaux même si ce n’est pas parfait

Voici une partie de l’output de mon entraînement :

```
===== TRAINING =====
Epoch 1  | Loss = 3.2865 | Acc = 62.7%
Epoch 3  | Loss = 0.6325 | Acc = 77.5%
Epoch 8  | Loss = 0.2455 | Acc = 84.2%
...
Epoch 10 | Loss = 0.1874 | Acc = 85.0%
...
Epoch 20 | Loss = 0.0879 | Acc = 87.8%
...
Epoch 30 | Loss = 0.0385 | Acc = 80.8%

Best accuracy: 87.75%

Confusion matrix (rows = true, cols = pred):
              cheetah   hyena   jaguar   tiger
cheetah         85        3       11        1
hyena            7       89        0        4
jaguar          12        1       85        2
tiger            6        1        1       92
```

## classification MLJFlux

Comme pour la classification Lux, nous avons utilisé la base de données contenant des images de 4 espèces d’animaux différents: des jaguars, des tigres, des guépards et des hyènes. 

### Importation des données

La première étape pour pouvoir entraîner un réseau de neurones était d’importer les données. Nous avons ainsi créé la fonction load_dataset() qui permet d’importer un jeu de données d’images en redimensionnant les images à la taille souhaitée. (voir avec Jana si on à mis la même chose)

### Transformation des données en scientific type

Une fois les images importées, il faut transformer les labels pour qu’ils aient le Multiclass scientific type qui est un type créé spécialement pour le MLJ et qui indique que l’on va devoir prédire une classe parmi 4 différentes.

### Construction du builder MyConvBuilder et utilisation de la fonction MLJFlux.build

Ensuite, on crée un builder qui permettra de pouvoir travailler sur n’importe quel type d’images parce qu’on peut définir la taille des filtres de convolution et le nombre de canaux qui permettent de définir si l’image est en couleur ou pas.

Puis grâce à la fonction MLJFlux.build qui est une fonction du package MLJFlux, on voit qu’on définit quelles couches et le nombres de couches qui vont être utilisées (ici une alternance de couche de convolution et de couche de maxpooling). 

Ainsi grâce au builder et à cette fonction, l’utilisateur n’a pas besoin de préciser la dimension des images, ni le nombre de classes ni si les images sont en noir et blanc ou en couleur.


### Définition du modèle

Grâce au modèle MLJFlux prédéfini on peut définir plusieurs hyper-pramètres du modèle: la taille des filtres de convolution, la taille des canaux, la taille des batch(=lot de photos qui vont être traitées en même temps dans une itération), le nombre d’epochs (=nombre de fois où l’ensemble des données vont être traitées) et la reproductibilité de l’aléatoire du réseau.

### Liaison du modèle, subset et entraînement

Nous avons ensuite lié le modèle avec les données dans une machine MLJ qui va créer un objet contenant les données et le modèle et cet objet sera prêt à être entraîné.

### Sauvegarde du modèle

Comme l’entraînement prend du temps, nous sauvegardons le modèle que nous pourrons réutiliser sans avoir à refaire l’entraînement en le chargeant directement.

### Prédiction et évaluation du modèle

Nous avons finalement prédit des données dans le but de voir comment le modèle fonctionne. Pour ce faire nous avons calculé l’accuracy (Accuracy = 0.595) modèle à savoir combien de fois il avait prédit la bonne valeur sur le nombre total de prédictions. Et finalement pour voir plus précisément là où le modèle s’est plus ou moins trompé en fonction des catégories, nous avons généré une matrice de confusion.

## Conclusion à la classification d'images : (Matteo)

## Metaprogrammation

Dans cette partie du projet, nous avons travaillé sur la métaprogrammation en Julia. Notre objectif était de créer automatiquement différents types d’animaux, de générer des fonctions de manière automatique, et d’utiliser le multiple dispatch pour définir des comportements propres à chaque espèce. L’idée était également de rendre notre code flexible et réutilisable, sans avoir à écrire manuellement une cinquantaine de structures ou de fonctions.

### 1. Le dictionnaire des animaux

Au lieu d’écrire les structures (Cheetah, Hyena, Tiger…) à la main, nous avons commencé par créer un dictionnaire

```julia
const ANIMAL_PROPERTIES = Dict(
    "Cheetah" => [:name, :weight, :speed],
    "Hyena"   => [:name, :stocky, :clan],
    "Jaguar"  => [:name, :swimmer, :jaw_strength],
    "Tiger"   => [:name, :avg_thickness_scratches, :territorial, :strength]
)

```

Ce dictionnaire contient pour chaque animal la liste de ses champs.

### 2. La macro `@describe`

Nous avons écrit une macro qui affiche automatiquement les champs d’un animal :

```julia
macro describe(animal_expr)
    animal = esc(animal_expr)
    return quote
        println("=== Description automatique ===")
        println("Type: ", typeof($animal))
        for f in fieldnames(typeof($animal))
            println("$(f): ", getfield($animal, f))
        end
        println("===============================")
    end
end

```

Cette macro @describe sert à afficher automatiquement toutes les informations d’un animal sans que nous ayons besoin d’écrire une fonction spéciale pour chaque type (Cheetah, Hyena, Tiger..)

Quand on utilise @describe mon_animal, Julia ne lit pas la variable comme une valeur, mais comme de code. ce qui permet de travailler directement sur le code. C’est un principe important de la métaprogrammation.

Dans la macro, la ligne animal = esc(animal_expr) indique à Julia de ne pas évaluer l’expression tout de suite, mais de la laisser telle quelle afin que la macro puisse l’utiliser correctement. Le bloc quote ... end correspond au code que la macro renvoie et qui sera exécuté  et typeof(animal), Cela permet d’obtenir le type exact de l’animal(par exemple Cheetah Hyena ou tiger). Ensuite, fieldnames(typeof(:animal)) permet d’obtenir la liste de tous les champs du type, et getfield(:animal, f) sert à lire à la valeur de chaque champ. A la fin, la macro imprime toutes les infos de manière propre, sans rien écrire manuellement pour chaque structure. cette macro me permet d’éviter d’écrire 4 fonctions différentes pour afficher les informations des animaux.

### 3.Creation automatique des structure

Nous avons utilisé une boucle qui génère les structures, au lieu d’écrire `struct Cheetah`, `struct Hyena`...

```julia
abstract type AbstractAnimals end

for (animal, fields) in ANIMAL_PROPERTIES
    struct_sym = Symbol(animal)
    @eval mutable struct $(struct_sym) <: AbstractAnimals
        $(fields...)
    end
end
```

Avec le dictionnaire (ANIMAL*PROPERTIES) qui contient le nom de chaque animal et la liste de ses champs, nous parcourons ce dictionnaire, et pour chaque animal nous construisons le nom de la structure avec Symbol(animal), puis nous utilisons @eval pour générer et évaluer du code qui définit la structure. La boucle for (animal, fields) in ANIMAL*PROPERTIES parcourt le dictionnaire : animal correspond au nom, et fields à la liste des champs (par exemple : name).

Nous transformons ensuite le texte "Cheetah" en symbole :Cheetah. Un symbole en Julia, c’est simplement un nom stocké comme une donnée. Ce n’est pas une chaîne de caractères : c’est une sorte d’étiquette que Julia peut utiliser pour générer du code.

Par exemple :cheetah représente simplement le nom Cheetah En métaprogrammation, Julia a besoin de ces noms pour fabriquer des types ou des fonctions automatiquement.

@eval permet de générer du code. Ici, Julia va  créer un struct qui s’appelle Cheetah, Hyena, etc mutable signifie que les champs peuvent être modifiés. <: AbstractAnimals veut dire que le struct hérite du type abstrait 

:$

(fields...) ici Julia insère automatiquement la liste des champs dans le struct. Par exemple, pour un guépard : name, weight, speed

### 4. Génération d’animaux aléatoires

Ici, nous avons créé une fonction qui produit un animal avec des attributs aléatoires. La fonction random*value attribue une valeur à chaque champ d’un animal, ce qui nous permet de créer des animaux différents à chaque exécution. La fonction make*random*animal utilise ce principe : elle vérifie quels champs appartiennent à l’animal dans le dictionnaire, génère pour chacun une valeur aléatoire, puis construit l’animal. Pour cela, elle transforme le nom de l’animal en symbole (Symbol(animal*type)) et utilise eval pour créer une instance du type correspondant avec les valeurs générées.

```julia

function random_value(field)
    if field == :name
        return ["Chester","Flash","Speedy","Dart","Bolt"][rand(1:5)]
    elseif field == :weight
        return rand(50:70)
    elseif field == :speed
        return rand(100:120)
    elseif field == :stocky
        return rand(Bool)
    elseif field == :clan
        return rand(20:40)
    elseif field == :swimmer
        return rand(Bool)
    elseif field == :jaw_strength
        return ["Très puissante","Extrêmement puissante","Puissante"][rand(1:3)]
    elseif field == :avg_thickness_scratches
        return rand(5:25)
    elseif field == :territorial
        return rand(Bool)
    elseif field == :strength
        return rand(1400:1800)
    end
end

function make_random_animal(animal_type::String)
    fields = ANIMAL_PROPERTIES[animal_type]
    values = [random_value(f) for f in fields]
    struct_sym = Symbol(animal_type)
    return eval(:( $(struct_sym)($(values...)) ))
end

```

### 5. Multiple dispatch : interactions entre animaux

Le multiple dispatch en Julia, c’est juste le fait que Julia choisit automatiquement la bonne version d’une fonction selon les types des arguments. Ça veut dire que nous pouvons écrire plusieurs fonctions qui ont le même nom, mais qui réagissent différemment selon les animaux qu’on lui donne. Nous avons utilisé le multiple dispatch pour définir des interactions différentes selon les types d'animaux, Par exemple, nous avons écrit :

```julia

interact_meta(a::AbstractAnimals, b::AbstractAnimals)

```

c’est la version “générale”, qui marche pour tous les animaux : 

```julia

interact*meta(a::Cheetah, b::Hyena)

interact*meta(a::Tiger, b::Tiger)

```

Chaque fois qu’on appelle interact_meta(x, y), Julia regarde les types de x et y et choisit automatiquement la bonne fonction. Donc si on envoie un Tiger et un Jaguar, Julia exécute la version Tiger Jaguar. Si on envoie deux Tiger, elle prend la version Tiger Tiger

Ça me permet d’avoir des comportements différents pour chaque combinaison d’animaux, sans faire de gros if partout.

### Définition d’un opérateur

On a défini un opérateur spécial ⨳ qui fonctionne différemment selon les espèces. C’est exactement le même principe que le multiple dispatch, mais ici ce n'est pas une fonction normale mais un opérateur

```julia

⨳(a::Cheetah, b::Hyena) = a.weight / b.clan

```

Si on fait guépard ⨳ hyène, julia va calculer cette formule et faire poids du guépard divisé par  taille du clan de la hyyena.

```julia
⨳(a::Hyena, b::Cheetah) = a.clan * b.speed
```

Ici c’est l’inverse si on mets une hyène puis un guépard, on utilise une autre formule Donc l’ordre des animaux change le résultat.

```julia
⨳(a::AbstractAnimals, b::AbstractAnimals) = length(a.name) + length(b.name)
```

Si Julia ne trouve pas de règle spécifique pour un 2 animaux, elle utilise la version generale. Donc c’est encore du multiple dispatch, mais appliqué à un opérateur,

### 7. Génération automatique de fonctions `process_*`

Ce bloc de code est métaprogrammation. La métaprogrammation c'est quand on écrit du code qui écrit du code Ici, je génère automatiquement 4 fonctions une pour chaque animal au lieu de les écrire manuellement une par une.

```julia
for animal in keys(ANIMAL_PROPERTIES)
    func_name = Symbol("process_", lowercase(animal))
    @eval begin
        function $(func_name)()
            println("\n=== Processing $(string($(QuoteNode(animal)))) ===")
            animal_instance = make_random_animal($(QuoteNode(animal)))
            @describe animal_instance

            # example of  interaction with a random generated cheetah
            cheetah = make_random_animal("Cheetah")
            if $(QuoteNode(animal)) != "Cheetah"
                interact_meta(animal_instance, cheetah)
                println("⨳ with Cheetah: ", animal_instance ⨳ cheetah)

            end

            return animal_instance
        end
    end
end

```

La boucle for animal in keys(ANIMAL*PROPERTIES) parcourt chaque nom d’animal. Ensuite, func*name = Symbol("process*", lowercase(animal)) construit le nom de la fonction sous forme de symbole. Par exemple pour "Tiger"  construit le symbole : process*tiger (dans metaprogramation quand on veut créer un nom de fonction ou variable,  a besoin d'un Symbol pas d'une String)

@eval est une macro qui permet d'évaluer et d'exécuter un code généré dynamiquement Tout ce qui est à l'intérieur du begin...end cré réellement la fonction, ce que la fonction fait: 

affiche qu’elle est en train de traiter un animal donné,

crée un animal aléatoire avec make*random*animal,

utilise @describe pour montrer ses champs,

génère aussi un guépard aléatoire, QuoteNode(animal) dit  “garde ce mot tel qu'il est  ne l’évalue pas”. donc si animal = "Tiger" alors QuoteNode(animal) garde  "Tiger" comme de texte, et Julia peut ensuite le mettre dans le code qu’elle fabrique 

Sans QuoteNode, Julia va essayer de jouer "Tiger" comme une variable ce qui a pas de sens donc ca permet qu'il soit un mot que on va utiliser dans le code

if :(QuoteNode(animal)) != "Cheetah" vérifie si l'animal actuel n'est pas un guépard Si c'est un guépard, on évite de le faire interagir avec lui-même 

Si l'animal n'est pas un guépard, on fait interagir les deux animaux  et calcule l’opérateur ⨳,

retourne l’animal généré.

ce code crée automatiquement 4 fonctions  sans que je les écrive une par une. Si j’ajoute un animal dans le dictionnaire, sa va cree une fonction process_nouvelanimal

## Bonito

Vous pouvez retrouver le projet en allant dans rapport puis Mackie. 

Pour pouvoir travailler sur Bonito nous avons dû mettre à jour les différents pkg. Ce qui nous prend du temps. Ensuite, nous avons étudié plusieurs exemples de notebooks interactifs disponibles pour Bonito pour comprendre le fonctionnement de l’interface. L’objectif principal de cette partie était de créer une application capable de visualiser et de classer des images, la même chose que le RShiny, mais en langage Julia.

Notre application sur bonito suit le même principe que celle sur R , c'est-à-dire que l’application permet à l’utilisateur de charger un dossier d’images et d’afficher ces images de manière interactive. Cependant nous n’avons pas réussi à mettre plus de fonctionnalité, car nous trouvons cela trop compliqué et complexe. À chaque fois que je rajoutais une autre fonction ou une autre fonctionnalité alors l’interface graphique avez des soucis pour l’affichage. 

Donc nous allons vous expliquer ce que nous avons fait dans le bonito. Pour la navigation entre les images, on a créé des boutons intégrés dans le notebook. Pour gérer cette organisation, on a utilisé le package Mackie, qui a des fonctionnalités pour créer des interfaces interactives et gérer la réactivité des éléments. Bonito nous a aussi permis d’afficher des notifications ou des messages de confirmation lorsque des images sont ajoutées à un dossier ou lorsqu’un dossier est créé. Ce qui est très bien utile car cela nous permet d’avoir un retour sur les actions, on voit si ça fonctionne ou non. 
Quand on clique sur un des deux boutons alors dans notre terminal on va recevoir un message qui nous dit qu’on est passé à l’index suivant. Ce qui nous confirme qu’il n’y a pas eu d’erreur, il fait exactement la même chose que le précédent. Nous avons également ajouté un slider qui me permet de changer de photo en fonction du curseur. Nous avons fait cela pour jouer un peu avec l’interface. 
Cette partie du projet nous a permis de comprendre les différences entre les environnements R et Julia pour la création d’applications interactives. Contrairement à RShiny, Bonito nécessite une approche plus orientée notebook, ce qui implique de structurer les cellules et le code de manière séquentielle tout en maintenant l’interactivité. 
Cette approche ouvre également la possibilité d’intégrer des modèles de classification automatiques via Flux ou d’autres packages Julia à l’avenir, ce qui permettra de compléter l’interaction manuelle avec des prédictions automatiques des catégories d’images. Mais une chose à redire que nous aurions du faire c’est de mettre notre package/fonction pour la classification. 


## Rshiny

Pour la partie Rshiny nous avons décidé de créer une application interactive qui nous permet de visualiser, organiser et  de classer les images de notre base de données dans différentes catégories (par exemple, “Tigre”, “Hyène”, “Cheetah”, et on peut créer de nouvelles catégories si besoin). Je me suis d’abord formé au Rshiny avant de commencer à travailler la dessus. Ce qui m’a pris du temps pour pouvoir comprendre les grandes lignes.  Pour la suite, à chaque fois que j’avais besoin de créer quelque chose de spécifique nous allions chercher dans la bibliothèque des packages de Rshiny.  Puis on a fait une leçon sur posit (la bibio) https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/ Ce qui nous a bien plus aidée que de regarder des tutos sur youtube. 

Nous sommes ensuite aller chercher sur posit un exemple de Rshniny classification, https://shiny.posit.co/r/gallery/life-sciences/biodiversity-national-parks/

L’interface que nous avons créée est une application qui permet de sélectionner un dossier d’images depuis l’ordinateur de l’utilisateur et d’afficher les images qu’il contient. Une fois cette étape réussie, nous avons prévu la possibilité de naviguer simplement entre les images grâce à des flèches « précédent » et « suivant », en utilisant une boucle itérative. Pour conserver un aspect de classification, nous souhaitons également permettre d’ajouter chaque image dans un dossier, de créer de nouveaux dossiers si nécessaire, puis de télécharger l’ensemble de ces dossiers sur l’ordinateur.

Pour ce projet, nous avons principalement utilisé les packages suivants :

  * shiny, un framework qui permet de créer des applications web interactives en R,
  * shinydashboard, une extension facilitant la mise en page sous forme de tableau de bord,
  * shinyFiles, qui permet à l’utilisateur de naviguer dans le système de fichiers local,
  * mime, qui sert à détecter le type de fichier (JPEG, PNG, GIF, etc.) avant l’affichage.

Lors de notre apprentissage, nous avons découvert qu’une application Shiny peut être organisée soit en un seul fichier, soit en deux fichiers distincts. Pour simplifier nos manipulations pendant le développement, nous avons choisi l’approche avec deux fichiers.

Le fichier principal prend donc la forme suivante :

```julia
ui <- dashboardPage(...)   # Interface utilisateur
server <- function(...)    # Logique du serveur
shinyApp(ui, server)        # Lancement de l'application
```

Dans les prochaines parties, nous décrirons plus en détail la manière dont nous avons codé l’application et les choix de conception que nous avons faits.

### a. Partie UI (User Interface)

Pour la partie interface, nous nous sommes basés sur un projet déjà existant présenté dans la documentation de RShiny. Cette partie gère tout l’aspect visuel et interactif de l’application. Elle est construite avec dashboardPage(), et comprend plusieurs éléments :

  * Un en-tête (header) qui affiche le titre de l’application : « Classification d’images ».
  * Une barre latérale (sidebar) contenant le logo et les liens vers l’Université Grenoble Alpes.
  * Un menu de navigation avec deux onglets :
  * Home, dédié à la classification d’images,

À propos de notre projet, où se trouve la description du travail réalisé (nous voulions nous entraîner à créer un menu de navigation).

### b. Partie Server

La partie serveur va gèrer : la sélection du dossier avec shinyDirChoose(). Mais aussi la lecture et le filtrage des images présentes dans le dossier choisi. Pour les boutons “Précédent” et “Suivant”, on va utiliser une logique de boucle pour les boutons. 

```julia
observeEvent(input:suivant, {     
    req(images())     
    idx = index() + 1     # on fait une boucle     
    if(idx > length(images())){       
        idx = 1       
    }  # boucle qui bouge vers la droite donc la fin du dossier (length(images))     
    index(idx)     
    updateSelectInput(session, "image", selected = basename(images())[idx])   
    }
)
```

Nous avons ensuite créé des conditions permettant de vérifier si un dossier existe déjà, et dans le cas contraire, de l’ajouter à notre liste de dossiers. Tous ces éléments sont créés directement sur l’ordinateur de l’utilisateur. Chaque action effectuée via les boutons met automatiquement à jour le menu déroulant pour refléter l’image actuellement affichée. C’est pour cette raison que, lors de chaque ajout d’image dans les dossiers de classification, une notification visuelle apparaît afin de confirmer l’action.

L’affichage des images est également géré par le serveur, qui détecte automatiquement le type de fichier grâce au package mime, ce qui garantit que chaque image est correctement rendue dans l’interface. Enfin, toutes les interactions sont réactives : toute modification — qu’il s’agisse de la sélection d’une nouvelle image, de la création d’un dossier ou de l’ajout d’une image — est immédiatement répercutée dans l’interface utilisateur. Cela offre une expérience fluide et intuitive pour la classification des images.

## Multiple Dispaching : animals

Dans cette partie du projet Julia, nous avons travaillé sur la création d’une hiérarchie d’animaux modélisés à l’aide de types abstraits, types concrets, et surtout du multiple dispatch, un des concepts centraux du langage Julia. Notre objectif était de définir un type abstrait commun représentant une famille d’animaux. Egalement de construire plusieurs types concrets héritant de ce type abstrait et de pouvoir personnaliser leur affichage en redéfinissant Base.show. Nous voulions égelement montrer l’intérêt du multiple dispatching à travers la gestion d’une liste d’animaux différents.

Ce travail a constitué la base avant d’aborder ensuite la métaprogrammation permettant de générer automatiquement des structures.

Nous avons d’abord défini un type abstrait :

```julia
abstract type AbstractAnimals end
```

Ce type nous permet de rassembler sous une même catégorie différents animaux possédant des attributs spécifiques. Ensuite, nous avons défini quatre types concrets, chacun héritant de AbstractAnimals : Cheetah,  Hyena, Jaguar et Tiger. Chaque type possède des champs adaptés à ses caractéristiques biologiques :

```julia
mutable struct Cheetah <: AbstractAnimals
    name::String
    weight::Int
    speed::Int
end

mutable struct Hyena <: AbstractAnimals
    name::String
    stocky::Bool
    clan::Int
end

mutable struct Jaguar <: AbstractAnimals
    name::String
    swimmer::Bool
    jaw_strength::String
end

mutable struct Tiger <: AbstractAnimals
    name::String
    avg_thickness_scratches::Int
    territorial::Bool
    strength::Int
end
```

Chaque structure représente un animal avec ses attributs propres. Le choix du mot-clé mutable nous permet de modifier les valeurs après la création d'un objet.

Initialement, nous avions tenté de gérer les différences entre espèces via une seule fonction :

```julia
function describe(animal::AbstractAnimals)
    if animal isa Cheetah
        
    elseif animal isa Hyena
        
    end
end
```

Même si cela fonctionne, ce n'est pas du tout idiomatique Julia, car cela contourne le multiple dispatch et ajoute un if/elseif manuel.

Nous avons donc corrigé cette erreur :  Julia permet de spécialiser le comportement d’une fonction selon les types en entrée. Nous avons choisi de redéfinir la méthode Base.show pour chaque animal, ce qui permet un affichage propre et automatique.

Exemple pour le guépard :

```julia
function Base.show(io::IO, animal::Cheetah)
    println(io,"Le guépard ", animal.name,
        " pèse ", animal.weight,
        " kg et peut aller jusqu'à ",
        animal.speed, " km/h.")
end
```

Nous avons fait de même pour Jaguar et Tiger.

Dans tous ls exemples suivants, nous utiliserons le vecteur suivant : 

```julia
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
```

Grâce à cela, afficher un animal se fait naturellement :

```julia
animals[17]
```

et retournera directement la phrase descriptive adaptée à l'espèce.

Nous avons également redéfini show pour gérer un tableau de différents animaux :

```julia
function Base.show(io::IO, animals::Vector{<:AbstractAnimals})
    for i in eachindex(animals)
        println(io, animals[i])
    end
end
```

Ce choix permet d’afficher toute une liste d’animaux avec :

```julia
animals
```

Même si les types sont différents, Julia sélectionne automatiquement la bonne méthode show pour chaque élément grâce au multiple dispatch. C’est précisément cette capacité qui rend Julia très puissant pour ce type de modélisation.

Pour illustrer nos définitions, nous avons créé une liste d’animaux, un vecteur mélangant tous les types (Cheetah, Hyena, Jaguar, Tiger) mais reste parfaitement manipulable grâce au type abstrait commun.

Dans cette partie du projet, nous avons donc appris à :

  * structurer un ensemble d’objets via un type abstrait,
  * définir des types concrets plus spécialisés,
  * tirer parti du multiple dispatch pour personnaliser le comportement selon chaque espèce,
  * redéfinir proprement Base.show,
  * manipuler un vecteur contenant des instances de différents types.

Ce travail a constitué une étape importante avant la phase de métaprogrammation, où nous avons ensuite automatisé la génération des structures et fonctions.

## Multiple Dispaching appliqué aux interactions entre animaux :

Après avoir défini plusieurs types concrets héritant de AbstractAnimals, nous avons mis en place un système d’interactions entre animaux basé sur le multiple dispatch. L’idée était d’illustrer pleinement la capacité de Julia à choisir automatiquement la bonne méthode selon les types des arguments fournis, sans utiliser de if, de typeof, ou d’autres techniques moins idiomatiques.

Nous avons commencé par définir une version générique de l’interaction :

```julia
function interact(a::AbstractAnimals, b::AbstractAnimals)
    println(a.name, " observe prudemment ", b.name, ".")
end
```

Cette version s’applique à toute combinaison d’animaux pour laquelle nous n’avons pas défini de méthode plus spécifique.

Nous avons ensuite défini des interactions spécifiques entre certaines paires d’animaux : Exemple : Guépard et Hyène

```julia
function interact(a::Cheetah, b::Hyena)
    println("Le guépard ", a.name,
            " tente de voler une proie à la hyène ",
            b.name, " du clan de ", b.clan, " membres !")
end
```

Cela peut également fonctionner entre deux animaux de même type Exemple de l'interaction entre deux tigres : 

```julia
function interact(a::Tiger, b::Tiger)
    if a.territorial && b.territorial
        println("Les tigres ", a.name,
                " et ", b.name,
                " se disputent le territoire !")
    else
        println("Les tigres ", a.name,
                " et ", b.name,
                " cohabitent paisiblement.")
    end
end
```

Nous avons ensuite inclus nos définitions et exécuté plusieurs interactions pour vérifier que Julia sélectionnait automatiquement la bonne méthode :

```julia
include("animals.jl")
```

Exemple d'appel d'exemple entre Guépard et Hyène

```julia
interact(animals[5], animals[7])
interact(animals[7], animals[5])
```

À chaque appel, Julia choisit automatiquement la méthode la plus spécifique, démontrant la puissance du multiple dispatching.

Grâce à cette approche, nous avons construit un système d'interactions :

  * extensible (il suffit d’ajouter un nouveau type et ses méthodes interact)
  * lisible (aucun test if animal isa ...)
  * parfaitement adapté à la philosophie du langage Julia

Cette partie illustre concrètement pourquoi Julia repose autant sur le multiple dispatch : il permet d’écrire un code clair, élégant et extrêmement flexible.

## Multiple Dispaching, operateurs

Pour cette partie, nous avons choisi d’explorer la surcharge d’opérateurs en Julia ainsi que le double dispatch, qui permet de déclencher automatiquement une méthode différente selon les types exacts des deux opérandes.

Nous avons d’abord sélectionné un opérateur Unicode reconnu par Julia : ⊔. Après vérification avec Base.isoperator(:⊔), qui nous renvoie true, nous pouvons le surcharger comme n’importe quel opérateur classique.

Nous avons commencé par définir un comportement générique, applicable lorsque l’opérateur est utilisé entre deux animaux pour lesquels aucune méthode spécialisée n’existe :

```julia
a::AbstractAnimals ⊔ b::AbstractAnimals = string(a.name, " et ", b.name,
    " n'ont pas d'opérateurs pour l'instant :(")
```

Ensuite, nous avons défini plusieurs cas spécialisés, exploitant la puissance du multiple dispatch. Par exemple, pour un guépard et une hyène, nous avons écrit :

```julia
a::Cheetah ⊔ b::Hyena = string("Le guépart ", a.name,
    " et la hyène ", b.name, " ne s'aiment pas du tout")
```

Nous avons aussi implémenté un opérateur mettant en évidence la différence de force entre deux tigres :

```julia
a::Tiger ⊔ b::Tiger = string("Le tigre ", a.name, " a une force de ",
    a.strength, "N, tandis que ", b.name, " lui, en a une de ",
    b.strength, "N !")
```

Grâce à ces définitions successives, Julia choisit automatiquement la bonne méthode en fonction du type exact de chaque animal, sans qu’aucune condition if ou switch ne soit nécessaire.

Test de l'opérateur entre un guépard et une hyène :

```julia
animals[1] ⊔ animals[6]
```

## Random sample

Dans cette partie, nous avons développé un système pour charger et échantillonner des images d’animaux à partir d’un répertoire local. L’objectif était de rendre l’accès aux images flexible, afin de faciliter leur utilisation dans des expériences ou des modèles de classification.

Nous avons créé une structure mutable AnimalSampler pour centraliser les informations relatives aux images disponibles :

```julia
mutable struct AnimalSampler
    root::String            # répertoire racine
    animals::Vector{String} # liste des animaux
end
```

  * root : le chemin racine où sont stockés les dossiers d’images.
  * nimals : liste des animaux présents dans les sous-dossiers.

Cette structure nous permet de passer facilement les informations à nos fonctions d’échantillonnage.

Nous avons ajouté une fonction utilitaire pour récupérer le chemin complet du dossier d’un animal

```julia
function get_animal_dir(s::AnimalSampler, animal::String)
    return joinpath(s.root, "data", "train", animal)
end
```

Cela simplifie toutes les opérations ultérieures, puisqu’on peut accéder directement aux images d’un animal donné.

Nous avons défini une méthode rand spécialisée pour tirer n images d’un animal spécifique :

```julia
function Base.rand(s::AnimalSampler, animal::String, n::Int)
    animal_dir = get_animal_dir(s, animal)
    all_files = glob("*.jpg", animal_dir)
    if isempty(all_files)
        @warn "Aucune image trouvée pour $animal dans $animal_dir"
        return []
    end
    n = min(n, length(all_files))
    sampled_files = rand(all_files, n)
    return [load(f) for f in sampled_files]
end
```

  * glob("*.jpg", animal_dir) liste toutes les images JPEG disponibles,
  * rand(all_files, n) permet de sélectionner aléatoirement n fichiers,

La fonction retourne un vecteur d’objets images chargés avec load.

Nous avons ensuite étendu cette fonctionnalité pour tirer un nombre fixe d’images pour chaque animal :

```julia
function Base.rand(s::AnimalSampler, n::Int)
    sampled = Dict{String, Vector{Any}}()
    for animal in s.animals
        imgs = rand(s, animal, n)
        sampled[animal] = imgs
        println("$animal : $(length(imgs)) images échantillonnées")
    end
    return sampled
end
```

Ainsi, pour chaque animal, nous obtenons n images échantillonnées de manière indépendante, avec affichage du nombre exact de fichiers récupérés.

Enfin, nous avons implémenté une fonction rand_all pour tirer un nombre total d’images réparties entre tous les animaux :

```julia
function rand_all(s::AnimalSampler, n::Int)
    all_paths = []
    for animal in s.animals
        animal_dir = get_animal_dir(s, animal)
        files = glob("*.jpg", animal_dir)
        append!(all_paths, [(animal, f) for f in files])
    end
    isempty(all_paths) && error("Aucune image trouvée dans $(s.root_dir)")
    n = min(n, length(all_paths))
    sampled_pairs = rand(all_paths, n)
    sampled_images = Dict{String, Vector{Any}}()
    for (animal, path) in sampled_pairs
        push!(get!(sampled_images, animal, []), load(path))
    end
    for (animal, imgs) in sampled_images
        println("$animal : $(length(imgs)) images échantillonnées")
    end
    return sampled_images
end
```

Cette approche nous permet de mélanger aléatoirement les images de tous les animaux et de récupérer un échantillon global.

Nous avons testé notre implémentation avec différents scénarios :

```julia
using ImageClassification

# Définition du répertoire et liste d’animaux
root = pwd()
animals = ["cheetah", "hyena", "tiger", "jaguar"]

# Création du struct
sampler = AnimalSampler(root, animals)

# Obtenir le chemin du dossier "cheetah"
get_animal_dir(sampler, "cheetah")

# Tirer 5 images d'un guépard
rand(sampler, "cheetah", 5)

# Tirer 8 images pour chaque animal
sampled_by_animal = rand(sampler, 8)

# Tirer 20 images au total, réparties entre tous les animaux
sampled_global = rand_all(sampler, 20)
```

À chaque exécution, nous obtenons un échantillon aléatoire différent, ce qui rend notre système flexible pour la classification ou l’entraînement de modèles.

Grâce à AnimalSampler et aux méthodes d’échantillonnage, nous avons pu :

  * échantillonner un nombre fixe d’images par animal ou globalement,
  * préparer facilement les images pour des expériences en classification ou apprentissage automatique.

Cette approche démontre comment Julia permet de combiner types personnalisés, fonctions redéfinies et manipulation de fichiers de manière claire et efficace.

## Loading

Dans cette section, nous avons développé des fonctions permettant de charger des images depuis un répertoire et de les préparer pour des tâches de classification ou d’apprentissage automatique. L’objectif était de standardiser la taille des images et de gérer correctement les couleurs.

Pour simplifier l’accès aux images, nous avons défini un chemin racine :

```julia
const root_dir = joinpath(dirname(@__FILE__),"..","..")
```

Cela nous permet de retrouver le dossier data depuis n’importe quel script, sans avoir à coder le chemin absolu.

Nous avons créé une fonction qui prend en entrée le chemin d’une image, la charge et la redimensionne en une taille standard (par défaut 200×200 pixels) :

```julia
function load_image(path; dataset::AbstractString = "train", size=(200,200))
    full_path = joinpath(root_dir, "data", dataset, path)
    img = FileIO.load(full_path)                # Charger l'image
    img_rgb = colorview(RGB, img)              # Vérifier que l'image est en RGB
    img_resized = imresize(img_rgb, size)      # Redimensionner
    return img_resized
end
```

  * FileIO.load : charge l’image depuis le fichier.
  * colorview(RGB, img) : convertit l’image en RGB si ce n’est pas déjà le cas.
  * imresize : redimensionne l’image pour obtenir une taille uniforme.

Cela nous garantit que toutes les images auront la même dimension et le même format de couleur, ce qui est essentiel pour l’analyse et l’entraînement de modèles.

Pour automatiser le chargement des données, nous avons défini la fonction load_dataset :

```julia
function load_dataset(;dataset::AbstractString = "train", size=(200,200))
    imgs = []     # liste pour stocker les images
    labels = []   # liste pour stocker les labels
    base_dir = joinpath(root_dir,"data/$dataset")
    classes = readdir(base_dir)
    for (i, cls) in enumerate(classes)
        class_dir = joinpath(base_dir, cls)
        for path in readdir(class_dir)
            img = load_image(joinpath(cls, path); dataset=dataset, size=size)
            push!(imgs, img)
            push!(labels, cls)
        end
    end
    return imgs, labels
end
```

Cette fonction commence par parcourir tous les sous-dossiers du dataset (train, validation, etc.), chaque sous-dossier correspondant à une classe d’animaux. Charge ensuite toutes les images avec load_image, et les redimensionne. Stocke les images dans un vecteur imgs et les labels correspondants dans labels. Ainsi, nous obtenons un vecteur de matrices d’images et un vecteur de labels, prêt à être utilisé pour des tâches de classification.

Nous avons testé nos fonctions avec différents cas d’usage :

```julia
using ImageClassification

# Charger une image spécifique
load_image(joinpath("cheetah","cheetah_000_resized.jpg"))

# Charger toutes les images du dossier "train"
train_imgs, train_labels = load_dataset()

# Charger les images du dossier "validation"
val_imgs, val_labels = load_dataset(dataset = "validation")
```

Chaque appel produit des images redimensionnées et prêtes à l’emploi, et nous permet de vérifier facilement le format et la qualité des données.

Avec load*image et load*dataset, nous avons mis en place un système flexible pour charger des images depuis différents répertoires, une uniformisation de la taille et du format des images et,une organisation claire des labels, nécessaire pour l’apprentissage supervisé.

## Type creation

Pour bien comprendre ce qu’est un type, un sous-type et un struct dans julia, nous avons décidé de créer des types, des sous-types et des struct. Nous avons donc commencé par créer un type abstrait: Animal et deux sous-types abstraits: Carnivore et Herbivore et finalement nous avons créé un struct pour les Carnivore: Loup et un struct pour les Herbivore: Cerf. Nous avons ensuite ajouté à ces struct des attributs. Nous avons ensuite créé une fonction: “crier” qui en fonction du type abstrait qu’elle recevrait n’aurait pas la même réponse. La fonction renvoie bramer si le type d’entrée est cerf et hurler si le type d’entrée est loup. Ce qui permet de mieux comprendre comment fonctionne le multiple dispatching et comment il est possible avec une même fonction de réaliser différents type d’actions en fonction du type d’entrées. 

## Tests

Nous avons choisis de compléter notre projet d'un ensemble de tests unitaires pour vérifier le bon fonctionnement des différentes fonctionnalités de notre package. Les tests sont organisés en cinq parties principales, chacune correspondant à un aspect spécifique. Par exemple, nous testons la création et description d'animaux :

```julia
using Test
using ImageClassification

@testset "Tests création et description d'animaux" begin
    animal = make_random_animal("Cheetah")
    @test animal isa Cheetah
    @test hasfield(Cheetah, :name)
    @test hasfield(Cheetah, :speed)
    @test typeof(animal.name) == String

    cheetah = Cheetah("Flash", 60, 110)
    ex = macroexpand(ImageClassification, :(@describe(cheetah)))
    @test isa(ex, Expr)
end
```

Nous avons en tout réalisés ainsi 5 test unitaires de fonctionnalités de notre package. Ils son ttous stockés dans le dossier 'unit' dans la section 'test'.

Finalement, le fichier 'runtests.jl" centralise tous les tests unitaires et les exécute dans un seul ensemble :

```julia
using Test
using ImageClassification

@testset "ImageClassification.jl" begin
    include("unit/load.jl")
    include("unit/interactions.jl")
    include("unit/operateurs.jl")
    include("unit/random_sample.jl")
    include("unit/animals.jl")
end
```

L'exécution de cette partie de code renvoie le retour de chaque test ainsi qu'un tableau de scores indiquant combien de tests sont passés, ont échoué ou ont provoqué une erreur.

Cela permet de s'assurer que l'ensemble des fonctionnalités sont testées et que chacune reste correcte après modification.

