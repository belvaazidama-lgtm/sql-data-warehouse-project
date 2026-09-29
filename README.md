# Projet d'Entrepôt de Données SQL
Construction d'un entrepôt de données moderne avec SQL server, incluant processus ETL, Analyse et modélisation de données.

Bienvenue dans ce projet de structuration et de gestion de données. L'objectif principal est de transformer des informations brutes, souvent désordonnées et éparpillées, en une base de données propre, fiable et directement exploitable pour la prise de décision.

## Le Problème et la Solution

Dans une entreprise, les informations proviennent souvent de plusieurs sources différentes comme des fichiers texte, des bases de données clients ou des logiciels de vente. Si l'on tente de réaliser des analyses directement sur ces fichiers d'origine, les calculs deviennent lents, des erreurs apparaissent et les chiffres risquent de ne pas correspondre.

La solution consiste à construire un entrepôt de données. Il s'agit d'un espace centralisé et structuré dans lequel toutes les informations sont rassemblées, nettoyées et organisées de façon fluide.

## Le Parcours de la Donnée en Trois Étapes

Pour garantir la qualité des informations, les données traversent trois niveaux successifs.

### La Réception (Niveau Bronze)
Ce premier niveau sert de point d'entrée. On y dépose les données brutes exactement comme elles arrivent de leurs systèmes d'origine, sans modifier leur contenu. Cela permet de conserver un historique intact des données de départ.

### Le Nettoyage (Niveau Silver)
Cette étape intermédiaire constitue le cœur du travail de préparation. C'est ici que l'on supprime les doublons, corrige les erreurs de saisie et harmonise le format des dates ou des textes afin que toutes les tables partagent les mêmes standards.

### La Restitution (Niveau Gold)
Ce dernier niveau regroupe les données finales sous forme de vues simplifiées. Les informations y sont combinées par thèmes clairs, comme les ventes, les clients ou les produits. C'est cette couche que consultent les outils de rapport et de visualisation graphique.

## Outils utilisés

**Notion :** L'espace d'organisation utilisé pour documenter le projet, suivre les tâches et consigner les décisions de conception.

**Draw.io :** L'outil visuel servant à concevoir le schéma d'architecture et modéliser le flux des données à chaque étape.

**Docker :** La technologie de conteneurisation utilisée pour exécuter l'environnement SQL Server de façon isolée, portable et rapide à déployer.

**SQL Server :** Le moteur qui stocke l'ensemble des données et exécute les requêtes.

**T-SQL (Scripts SQL) :** Le langage d'instructions utilisé pour créer les tables, nettoyer les lignes et construire les vues d'analyse.

## Organisation du Dépôt

Le dossier Bronze contient les instructions pour importer les données d'origine dans le système.

Le dossier Silver regroupe les règles de nettoyage et de vérification de la qualité des données.

Le dossier Gold renferme les vues finales structurées pour l'analyse métier et le reporting.
