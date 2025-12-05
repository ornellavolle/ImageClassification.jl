# Rapport Projet Julia

Ornella Jana  Matteo Anna

## Introduction (ornella)

Dans le cadre de notre projet julia nous avons déterminé comme objectif de base la classification d’images. Nous voulions créer notre propre méthode de classification en utilisant les réseaux de neurones (CNN) mais par manque de temps nous avons décidé de faire plusieurs exercices, par exemple de la métaprogramation, du multipledispaching, et de la classification (package Flux et par lux) dont le centre était une classification des animaux (cheetah, tigre, hyene et jaguar). Pour avoir une représentation graphique de ce que nous faisions, nous avons décidé de créer une application interactive sous R (Rshiny) et sous Julia (Bonito).  

## Le dataset : (qui veut, Matteo ?)

```julia (editor=true, logging=false, output=true)

```
## La classification Lux (Jana)

J’ai travaillé sur la classification d’images avec Lux. Le but était d’entraîner un réseau de neurones convolutionnel qui peut reconnaitre automatiquement les 4 animaux : cheetah, tiger, jaguar et hyena. L’objectif était de comprendre comment on construit un modèle Lux: chargement des images, préparation des données, création du modèle, entraînement, évaluation et prédiction.

J’ai donc appris comment mettre les images au bon format, normaliser les pixels, définir un CNN avec plusieurs couches convolution, puis entraîner le modèle avec une boucle de training. J’ai aussi ajouté des fonctions pour tester l’accuracy, afficher des prédictions et sauvegarder le modèle pour le réutiliser plus tard. Ça m’a permis de comprendre vraiment comment fonctionne Lux 

Lux n’a pas de fonction pour entraîner un modèle Au début c’était un peu difficile, et plus de travail, mais en même temps ça m’a aidé a comprendre vraiment comment un réseau de neurones apprend, puisque il n’y a pas de train prêt, je dois construire le training étape par étape(la normalization, data augemntation,compute_loss,etc)

```julia (editor=true, logging=false, output=true)
function load_images(data_dir; img_size=(64,64))
```
Cette fonction prend toutes les images du dossier et les met dans le bon format pour Lux. Elle regarde les sous dossiers (cheetah, tiger, etc, puis pour chaque image elle la charge, la redimensionne en 64×64 et la transforme en array Float32 avec les trois RGB. À chaque image ajoutée, j’ajoute aussi son label (le numéro de la classe),par exemple cheetah = 1, hyena = 2, jaguar =3 tiger = 4. Ce numéro est le label de l’image car les modeles no prend pas des mots

Lux a besoin que les images soient dans ce format pour les envoyer dans le réseau de neurones. C’est pour ça que la fonction load_images construit un array en format HWCN (hauteur, largeur, canaux, nombre d’images).

C’est la préparation du dataset avant l’entraînement.

### 2. Normalisation et augmentation

La fonction normalize*train*test sert à mettre toutes les images à la même échelle.Ça aide le modèle à apprendre plus vite

La fonction augment_batch prend un batch d’images et fait un flip horizontal, ca permet d’ajouter  de variété dans les images et d’éviter que le modèle s’habitue trop a un seul type.

### 3. Le modèle Lux

La fonction create_cnn construit le modèle que j’utilise pour la classification. C’est un petit CNN classique : il a trois couches convolution pour extraire les formes dans l’image, chacune suivie d’un maxpool pour réduire la taille. MaxPool, ca réduit la taille de l’image tout en gardant les informations les plus importantes

Ensuite, j’ai défini la loss et la fonction de training.

### 4. L’entraînement du modèle

La fonction compute*loss calcule l’erreur du modèle. Elle prend les prédictions du modèle (y*pred) et les compare aux vraies classes (y). Le résultat est un nombre appelé “loss” plus il est petit, plus le modèle fonctionne bien.

La fonction train_epoch! entraîne le modèle pendant un epoch (un passage complet sur toutes les images). j’ai entraîné le modèle pendant 10 epochs À chaque epoch, j’affichais la loss et l’accuracy 

### 5. Évaluation et matrice de confusion

Cette partie sert à mesurer si le modèle a bien appris Pour évaluer le modèle, j’ai fait une fonction d’accuracy et une matrice de confusion :montre pour chaque classe combien d’images ont été bien ou mal classée

```julia (editor=true, logging=false, output=true)
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

J’ai aussi sauvegardé le modèle parce que l’entraînement prend longtemps (chez moi presque 2 heures). Donc sauvegarder le modèle évite de devoir tout réentraîner quand je veux juste tester ou prédire une image. Je peux juste charger le fichier .bson et utiliser le modèle directement.

j’ai aussi un fichier séparé qui s’appelle classification_lux.jl. Ce fichier n’entraîne pas le modèle : il sert seulement à charger le modèle déjà entraîné et à faire des prédictions sur de nouvelles images. En gros, dans luxClassification.jl j’ai fait tout le travail lourd (charger les données, entraîner pendant 2 heures, choisir le meilleur modèle, etc). Une fois que le modèle est prêt, je le sauvegarde dans modelLux.bson.

Dans classification_lux.jl, je fais l’inverse : je récupère le modèle déjà entraîné en chargeant ce fichier .bson. Ça évite complètement de relancer l’entraînement, ce qui serait trop long. le modèle est prêt en peu de temps.

Il contient  les fonctions utiles pour charger le modèle déjà entraîné et pour préparer les images avant la prédiction

```julia (editor=true, logging=false, output=true)
function load_lux_model()

```
pour charger le modèle sauvegardé

```julia (editor=true, logging=false, output=true)
function preprocess_lux_image()

```
pour mettre une nouvelle image dans le même format que pendant l’entraînement

```julia (editor=true, logging=false, output=true)
function predict_lux_class
```
renvoie le nom de l’animal

```julia (editor=true, logging=false, output=true)
function predict_lux_probabilities()

```
renvoie les probabilités pour chaque classe

Donc ici, je n’apprends plus le modèle, je l’utilise. Je prends une image, je la prépare, je la passe dans le modèle, et j’obtiens directement la classe prédite

Je ne lance pas ces fonctions directement dans ce fichier. Elles sont utilisées dans lux_predict.jl, qui est le script où je fais la prédiction d’une image

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

## Load (Anna)

```julia (editor=true, logging=false, output=true)

```
## Metaprogrammation (Jana)

Dans cette partie du projet, j’ai travaillé sur la métaprogrammation en Julia. L’objectif était de créer des types d’animaux automatiquement, de générer des fonctions automatiquement, et d’utiliser le multiple dispatch pour définir des comportements différents selon les espèces. L’idée était aussi de rendre le code flexible et réutilisable, sans devoir écrire manuellement 50 structures ou fonctions.

### 1. Le dictionnaire des animaux

Au lieu d’écrire les structures (Cheetah, Hyena, Tiger…) à la main, j’ai commencé par créer un dictionnaire

```julia (editor=true, logging=false, output=true)
const ANIMAL_PROPERTIES = Dict(
    "Cheetah" => [:name, :weight, :speed],
    "Hyena"   => [:name, :stocky, :clan],
    "Jaguar"  => [:name, :swimmer, :jaw_strength],
    "Tiger"   => [:name, :avg_thickness_scratches, :territorial, :strength]
)

```
Ce dictionnaire contient pour chaque animal la liste de ses champs.

### 2. La macro `@describe`

J’ai écrit une macro qui affiche automatiquement les champs d’un animal :

```julia (editor=true, logging=false, output=true)
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
Cette macro @describe sert à afficher automatiquement toutes les informations d’un animal sans que j’aie besoin d’écrire une fonction spéciale pour chaque type (Cheetah, Hyena, Tiger..)

Quand on utilise @describe mon_animal, Julia ne lit pas la variable comme une valeur, mais comme de code. ce qui permet de travailler directement sur le code. C’est un principe important de la métaprogrammation.

Dans la macro, la ligne animal = esc(animal_expr) indique à Julia de ne pas évaluer l’expression tout de suite, mais de la laisser telle quelle afin que la macro puisse l’utiliser correctement. Le bloc quote ... end correspond au code que la macro renvoie et qui sera exécuté  et typeof(animal), Cela permet d’obtenir le type exact de l’animal(par exemple Cheetah Hyena ou tiger). Ensuite, fieldnames(typeof(:animal)) permet d’obtenir la liste de tous les champs du type, et getfield(:animal, f) sert à lire à la valeur de chaque champ. A la fin, la macro imprime toutes les infos de manière propre, sans rien écrire manuellement pour chaque structure. cette macro me permet d’éviter d’écrire 4 fonctions différentes pour afficher les informations des animaux.

### 3.Creation automatique des structure

J’ai utilisé une boucle qui génère les structures, au lieu d’écrire `struct Cheetah`, `struct Hyena`...

```julia (editor=true, logging=false, output=true)
abstract type AbstractAnimals end

for (animal, fields) in ANIMAL_PROPERTIES
    struct_sym = Symbol(animal)
    @eval mutable struct $(struct_sym) <: AbstractAnimals
        $(fields...)
    end
end
```
avec le dictionnaire (ANIMAL*PROPERTIES) qui contient le nom de chaque animal et la liste de ses champs,laa boucle parcourt ce dictionnaire, et pour chaque animal elle construit le nom de la structure avec Symbol(animal), puis utilise @eval pour générer et évaluer du code qui définit  la structure. for (animal, fields) in ANIMAL*PROPERTIES parcourt le dictionnaire, animal = le nom ,fields = la liste des champs (ex: name). Je transforme le texte "Cheetah" en symbole :Cheetah. Un symbole en Julia, c’est juste un nom stocké comme une donnée. Ce n’est pas une chaîne de caractères, mais une comme une étiquette que julia peut utiliser pour créer du code.

Par exemple :cheetah représente simplement le nom Cheetah En métaprogrammation, Julia a besoin de ces noms pour fabriquer des types ou des fonctions automatiquement.

@eval permet de générer du code. Ici, Julia va  créer un struct qui s’appelle Cheetah, Hyena, etc mutable signifie que les champs peuvent être modifiés. <: AbstractAnimals veut dire que le struct hérite du type abstrait 

:$

(fields...) ici Julia insère automatiquement la liste des champs dans le struct. Par exemple, pour un guépard : name, weight, speed

### 4. Génération d’animaux aléatoires

Ici j'ai crée une fonction qui produit un animal avec des attributs aléatoires La fonction random*value donne une valeur à chaque champ d’un animal,cela permet de créer des animaux différents à chaque exécution La fonction make*random*animal utilise ca. Elle regarde quels champs appartient à l’animal dans le dictionnaire, génère une valeur aléatoire pour lui, puis construit  l’animal, donc elle transforme le nom de l’animal en symbole (Symbol(animal*type)) et utilise eval pour créer une instance du  type avec les valeurs générées.

```julia (editor=true, logging=false, output=true)

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

Le multiple dispatch en Julia, c’est juste le fait que Julia choisit automatiquement la bonne version d’une fonction selon les types des arguments. Ça veut dire que je peux écrire plusieurs fonctions qui ont le même nom, mais qui réagissent différemment selon les animaux qu’on lui donne. J’ai utilisé le multiple dispatch pour définir des interactions différentes selon les types d'animaux, Par exemple, j’ai écrit :

```julia (editor=true, logging=false, output=true)

interact_meta(a::AbstractAnimals, b::AbstractAnimals)

```
c’est la version “générale”, qui marche pour tous les animaux J'ai aussi ecrit: 

```julia (editor=true, logging=false, output=true)

interact*meta(a::Cheetah, b::Hyena)

interact*meta(a::Tiger, b::Tiger)

```
Chaque fois qu’on appelle interact_meta(x, y), Julia regarde les types de x et y et choisit automatiquement la bonne fonction. Donc si j’envoie un Tiger et un Jaguar, Julia exécute la version Tiger Jaguar. Si j’envoie deux Tiger, elle prend la version Tiger Tiger

Ça me permet d’avoir des comportements différents pour chaque combinaison d’animaux, sans faire de gros if partout.

### Définition d’un opérateur

j’ai défini un opérateur spécial ⨳ qui fonctionne différemment selon les espèces. C’est exactement le même principe que le multiple dispatch, mais ici ce n'est pas une fonction normale mais un opérateur

```julia (editor=true, logging=false, output=true)

⨳(a::Cheetah, b::Hyena) = a.weight / b.clan

```
Si je fais guépard ⨳ hyène, julia va calculer cette formule et faire  poids du guépard divisé par  taille du clan de la hyyena.

```julia (editor=true, logging=false, output=true)
⨳(a::Hyena, b::Cheetah) = a.clan * b.speed
```
Ici c’est l’inverse si je mets une hyène puis un guépard, on utilise une autre formule Donc l’ordre des animaux change le résultat.

```julia (editor=true, logging=false, output=true)
⨳(a::AbstractAnimals, b::AbstractAnimals) = length(a.name) + length(b.name)
```
Si Julia ne trouve pas de règle spécifique pour un 2 animaux, elle utilise la version generale. Donc c’est encore du multiple dispatch, mais appliqué à un opérateur,

### 7. Génération automatique de fonctions `process_*`

Ce bloc de code est métaprogrammation. La métaprogrammation c'est quand on écrit du code qui écrit du code Ici, je génère automatiquement 4 fonctions une pour chaque animal au lieu de les écrire manuellement une par une.

```julia (editor=true, logging=false, output=true)
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
La boucle for animal in keys(ANIMAL*PROPERTIES) parcourt chaque nom d’animal. Ensuite, func*name = Symbol("process*", lowercase(animal)) construit le nom de la fonction sous forme de symbole. Par exemple pour "Tiger"  construit le symbole :process*tiger (dans metaprogramation quand on veut créer un nom de fonction ou variable,  a besoin d'un Symbol pas d'une String)

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

## Bonito (Ornella)

## R (Ornella)

Pour la partie Rshiny j’ai décidé de créer une application interactive qui nous permet de visualiser, organiser et  de classer les images de notre base de données dans différentes catégories (par exemple, “Tigre”, “Hyène”, “Cheetah”, et on peut créer de nouvelles catégories si besoin). Je me suis d’abord formé au Rshiny avant de commencer à travailler la dessus. Ce qui m’a pris du temps pour pouvoir comprendre les grandes lignes.  Pour la suite, à chaque fois que j’avais besoin de créer quelque chose de spécifique j’allais chercher dans la bibliothèque des packages de Rshiny.  Puis j’ai fait une leçon sur posit (la bibio) https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/ Ce qui m’a bien plus aidée que de regarder des tutos sur youtube. 

Je suis ensuite aller chercher sur posit un exemple de Rshniny classification, https://shiny.posit.co/r/gallery/life-sciences/biodiversity-national-parks/

Donc l’interface que j’ai créé est une application qui va permettre de sélectionner un dossier d’images depuis l’ordinateur de l’utilisateur, et d’afficher les images contenues dans ce dossier. Après avoir réussi il faut qu’on puisse naviguer simplement avec des flèches précédents et suivant, en faisant une boucle itérative. Pour garder cet aspect de classification j’aimerais pouvoir rajouter chaque image dans un dossier, et avoir la possibilité de créer de nouveaux dossiers, puis de pouvoir télécharger tous ces dossiers sur mon ordinateur.  Pour ce projet j’ai utiliser principalement les packages, shiny (framework permettant de créer des applications web interactives en R), shinydashboard (extension facilitant la mise en page sous forme de tableau de bord (“dashboard”)), shinyFiles (bibliothèque permettant à l’utilisateur de naviguer dans le système de fichiers local) et mime (pour détecter le type de fichier (JPEG, PNG, GIF, etc.) avant affichage) Quand je me suis formé j’ai vu qu’un Rshiny se divise en deux fichiers, ou alors en un seul fichier avec plusieurs parties, j’ai décidé d’utiliser les deux dossiers mais pour simplifier les manipulations lorsque je code.  Le fichier sera donc écrit comme ça :  ui <- dashboardPage(...)   # Interface utilisateur server <- function(...)    # Logique du serveur shinyApp(ui, server)    # Lancement de l'application Je vais décrire dans les prochaines parties comment j’ai coder et comment j’ai réfléchi. 

### a. Partie UI (User Interface)

Pour la partie interface je me suis basé sur un projet déjà existant, qui était donné dans la doc de Rshiny. Cette partie gère tout l’aspect visuel et interactif de l’application .Elle est construite avec dashboardPage() et il y a un en-tête (header) : qui affiche le titre de l’application étant “Classification d’images”. Une barre latérale (sidebar) qui contient le logo et les liens de l’Université Grenoble Alpes et il y a un menu de navigation avec deux onglets le “Home” pour la classification d’images et “ À propos de notre projet “ où il y aura la description du travail réalisé (je voulais m'entraîner à créer un menu de navigation).

### b. Partie Server

La partie serveur va gèrer : la sélection du dossier avec shinyDirChoose(). Mais aussi la lecture et le filtrage des images présentes dans le dossier choisi. Pour les boutons “Précédent” et “Suivant”, on va utiliser une logique de boucle pour les boutons. 

observeEvent(input:suivant, {     req(images())     idx = index() + 1     #on fait une boucle     if(idx > length(images())){       idx = 1       }  # boucle qui bouge vers la droite donc la fin du dossier (length(images))     index(idx)     updateSelectInput(session, "image", selected = basename(images())[idx])   })

J’ai ensuite créé des conditions qui me permettent de savoir si un dossier est déjà créé et sinon on peut le rajouter à notre liste de dossier, et tout ça va être créé directement sur l'ordinateur de l’utilisateur.  Chaque action sur ces boutons met à jour automatiquement le menu déroulant pour avoir l’image qui est actuellement affichée.C’est pour ça que pour chaque ajout d’images dans les dossiers de classification il va y avoir une notifications visuelles pour confirmer l’action.  L’affichage des images est également géré par le serveur, qui détecte automatiquement le type de fichier à l’aide du package mime afin de garantir que chaque image est correctement rendue dans l’interface. Enfin, toutes les interactions sont réactives, ce qui signifie que toute modification, qu’il s’agisse de la sélection d’une nouvelle image, de la création d’un dossier ou de l’ajout d’une image, est immédiatement reflétée dans l’interface utilisateur, offrant ainsi une expérience fluide et intuitive pour la classification des images.

## MD, animals (Anna)

```

julia (editor=true, logging=false, output=true)

```

## MD, interactions (Anna)

```

julia (editor=true, logging=false, output=true)

```

## MD, operateurs (Anna)

```

julia (editor=true, logging=false, output=true)

```

## random sample (Anna)

```

julia (editor=true, logging=false, output=true)

```

## type creation (Matteo)

```

julia (editor=true, logging=false, output=true)

```

## Tests (Anna)

```

julia (editor=true, logging=false, output=true)

```

