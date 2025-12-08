---
title: "Projet Julia - ImageClassification.jl"
subtitle: "Présentation"
author: "Jana Al Jamal - Anna Cochat - Matteo Schweizer - Ornella Volle"
format:
  revealjs:
    theme: moon # on a choisis ce style et ces couleurs
    slide-number: true
    transition: slide # glissage entre chaque slide
---

## Introduction

commande pour lancer le diapo à exécuter dans le temrinal : quarto preview presentation.md


Projet réalisé dans le cadre du master SSD (UGA).  
Objectifs : Construire un package Julia + classification d'images

---

## Structure du package

```text
ImageClassification/
├─ classificationLux/
├─ load/
├─ metaprogrammation/
├─ multiple_dispaching/
├─ random_sample/
└─ ImageClassification.jl
```

Chaque dossier correspond à une fonctionnalité du projet.

---

### Multiple dispatching : animals

##### Explications
Dans cette partie du projet Julia, nous avons travaillé sur la création d’une hiérarchie d’animaux modélisés à l’aide de types abstraits, types concrets, et surtout du multiple dispatching.

##### Type abstrait
Nous avons d’abord défini un type abstrait : 'AbstractAnimals'

##### Types concrets
Ce type nous permet de rassembler sous une même catégorie différents animaux possédant des attributs spécifiques. 
Ensuite, nous avons défini quatre types concrets, chacun héritant de AbstractAnimals.

##### Caractéristiques 
Nous avons choisi de redéfinir la méthode Base.show pour chaque animal, ce qui permet un affichage propre et automatique.

---

### Multiple dispatch : interactions entre animaux

Julia choisit automatiquement la bonne fonction selon les types des animaux.  

#### Une méthode générique :

```julia
interact(a::AbstractAnimals, b::AbstractAnimals) =
    println(a.name, " observe prudemment ", b.name)
```

#### Plus des méthodes spécifiques : 

```julia
interact(a::Cheetah, b::Hyena) =
    println("Le guépard ", a.name, " défie la hyène ", b.name)
```

#### Appels (sélection automatique de la bonne méthode) :

```julia
interact(animals[5], animals[7])
```
---

### Application RShiny

#### Objectif
Créer une application interactive pour visualiser, parcourir et classer des images dans des dossiers (Tigre, Hyène, Cheetah, etc.), avec possibilité de créer de nouvelles catégories.

#### Fonctionnement
- Sélection d’un dossier d’images via 'shinyFiles'.  
- Navigation entre les images (boutons 'Précédent' / 'Suivant').  
- Création de dossiers + ajout d’images avec mise à jour automatique de l’interface.  
- Détection du type d’image avec 'mime' pour un affichage correct.

#### Structure
- App en deux fichiers :  
  'ui.R' (interface : dashboardPage, menu, onglets)  
  'server.R' (logique : lecture d’images, navigation, classification).

---

### Les tests unitaires

Nous avons choisis de compléter notre projet d'un ensemble de tests unitaires pour vérifier le bon fonctionnement des différentes fonctionnalités de notre package. Les tests sont organisés en cinq parties principales, chacune correspondant à un aspect spécifique. 

#### Objectifs des tests

- Vérifier la cohérence du package  
- Tester séparément chaque fonctionalité  

#### Les tests sont regroupés dans

test/unit/
test/runtests.jl

Nous avons en tout réalisés ainsi 5 test unitaires de fonctionnalités de notre package. Ils son ttous stockés dans le dossier 'unit' dans la section 'test'.

Le fichier 'runtests.jl" centralise tous les tests unitaires et les exécute dans un seul ensemble.

L'exécution de cette partie de code renvoie le retour de chaque test ainsi qu'un tableau de scores indiquant combien de tests sont passés, ont échoué ou ont provoqué une erreur.
