# Ecommerce Data Warehouse with dbt

Projet d’Analytics Engineering construit avec **dbt** pour transformer des données e-commerce brutes en un modèle analytique exploitable (dimensions + faits) dans un data warehouse.
Projet complet d’**Analytics Engineering** visant à transformer des données e-commerce brutes en un **data warehouse structuré (modèle en étoile)** puis en un **dashboard décisionnel** conçu pour répondre à des problématiques business concrètes.

## Objectifs

- Construire une couche analytique fiable pour le suivi business e-commerce
- Standardiser les transformations avec **dbt** (SQL versionné, tests, lineage)
- Mettre en place un modèle en étoile (facts et dimensions) adapté à la BI
- Alimenter un **data warehouse BigQuery**
- Concevoir un **dashboard Power BI** orientré prise de décision
- Mettre en place un workflow versionné avec **Git/GitHub**

## Contexte & problématique

Le projet s’appuie sur le dataset e-commerce Olist (https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), contenant des données de :

- commandes
- produits
- clients
- vendeurs

Ces données sont initialement fragmentées et non structurées pour l’analyse.

Le besoin est de construire une couche analytique permettant de répondre à des questions telles que :

Comment évolue le chiffre d’affaires dans le temps ?
Quels produits et vendeurs génèrent le plus de revenu ?
Quels clients contribuent le plus au business ?
Comment se répartit l’activité géographiquement ?

## Stack

- **dbt Core**
- **SQL** (models staging / intermediate / marts)
- **BigQuery** (data warehouse)
- **Power BI** (visualisation)
- **Git / GitHub**

## Architecture du projet

Le projet dbt est structuré en 3 couches :

models/
├── staging/
├── intermediate/
└── marts/
    └── core/

*Le code dbt se trouve dans le dossier `ecommerce_project_ae/` :*

**Staging**
- Nettoyage et standardisation des sources
- Uniformisation des champs

**Intermediate**
- Enrichissements métier
- Jointures et transformations intermédiaires
Exemples :
- `int_orders_enriched`
- `int_order_items_enriched`

**Marts (core)**

Tables finales prêtes pour la BI :
- `fact_orders`
- `fact_order_items`
- `dim_customers`
- `dim_products`
- `dim_sellers`
- `dim_date`

## Modèle de données (vue d’ensemble)

Le modèle suit une logique de star schema :

- **Faits**
  - `fact_orders` : métriques au niveau commande (revenu, fret, délai de livraison, etc...)
  - `fact_order_items` : granularité ligne de commande (produit, vendeur, prix)
- **Dimensions**
  - `dim_customers` : informations clients
  - `dim_products` : informations produits et catégorie
  - `dim_sellers` : informations vendeurs
  - `dim_date` : calendrier analytique (jour, semaine, mois, trimestre, année)

Ce modèle permet :
- une lecture simple côté BI
- des performances optimisées
- une séparation claire des granularités

## Transformations principales

- Calcul du chiffre d’affaires (order + item level)
- Calcul des montants (prix, fret, revenu)
- Calcul des délais de livraison
- Enrichissement des données clients (localisation)
- Normalisation des catégories produits
- Création d’une dimension temporelle (`dim_date`)

## Tests de qualité

Le projet inclut des tests dbt sur les tables de marts pour garantir l'intégrité du modèle et la cohérence des relations :

- `not_null`
- `unique`
- `relationships`

## Lancer le projet en local

Depuis `ecommerce_project_ae/` :

```bash
dbt deps
dbt run
dbt test
```

Optionnel :

```bash
dbt docs generate
dbt docs serve
```
## Dashboard Power BI

Le dashboard est construit directement à partir des tables **marts** du data warehouse.

**- Overview (Performance globale)**
  - Revenue (CA total)
  - Total Orders (Nombre total de commandes)
  - Average Cart (Panier moyen)
  - Total Customers (Nombre total de clients)
  - Cancellation Rate (Taux d'annulation)

Visualisations : 
- Évolution du CA et du volume de commandes
- Classement des catégories de produits par CA réalisé
- Classement des états brésiliens par CA réalisé

Objectif : vision globale du business et identification rapide des drivers

**- Sales / Products (Analyse des ventes)**
  - Revenue (CA total)
  - Total Items Sold (Nombre total de produits vendus)
  - Distinct Items (Nombre total de produits uniques vendus)
  - Total Sellers (Nombre total de vendeurs)

Visualisations :
- Évolution du revenue produit
- Répartition du CA par catégorie
- Classement des produits par CA
- Classement des vendeurs par CA

Objectif : comprendre la génération du chiffre d'affaires

**- Customers (Analyse client)**
  - Total Customers (Nombre total de clients)
  - Average LTV (Valeur de la vie des clients)
  - Purchase Frequency (Fréquence d'achat)

Visualisations :
- Évolution du nombre de clients
- Classement des clients par CA
- Répartition géographique

Objectif : analyser la valeur et le comportement client

## Design & UX/UI

Le dashboard a été conçu avec une approche orientée expérience utilisateur :
- Structuration en 3 pages métier (Overview / Sales / Customers)
- Hierarchisation claire de l'information
- Utilisation du F-pattern
- Travail de design en amont pour une lecture plus fluide axé logique métier (Figma)
- Palette de couleurs cohérente avec l'entreprise Olist

Objectif : faciliter la lecture et la prise de décision

## Aperçu du dashboard

### Overview
docs/dashboard-overview.png

### Sales / Products
docs/dashboard-sales-products.png

### Customers
docs/dashboard-customers.png

## Modélisation BI & DAX
- Création de mesures :
  - Revenue
  - Total Orders
  - Average Cart
  - LTV
  - Purchase Frequency
- Utilisation de :
  - SUM
  - DISTINCTCOUNT
  - DIVIDE

Les calculs métiers sont volontairement séparés :
- transformations → dbt
- métriques → Power BI

## Points importants

- Les fichiers sensibles (ex. `.env`) sont ignorés.
- Les artefacts dbt (`target/`, `logs/`, `dbt_packages/`) sont ignorés.

## Connexion Power BI au data warehouse (BigQuery)

Le projet dbt alimente BigQuery sur :

- `project_id` : `analytics-ecommerce-project`
- `dataset` : `ecommerce_analytics`
- tables principales : `fact_orders`, `fact_order_items`, `dim_customers`, `dim_products`, `dim_sellers`, `dim_date`

### 1) Connecter Power BI Desktop

1. Ouvrir **Power BI Desktop**.
2. Aller dans **Obtenir des données** → **Google BigQuery**.
3. Se connecter avec un compte Google ayant accès au projet BigQuery.
4. Dans le navigateur BigQuery, sélectionner le dataset `ecommerce_analytics`.
5. Charger les tables du schéma en étoile :
   - `fact_orders`
   - `fact_order_items`
   - `dim_customers`
   - `dim_products`
   - `dim_sellers`
   - `dim_date`

### 2) Configurer le modèle dans Power BI

- Créer les relations 1-* depuis les dimensions vers les faits :
  - `dim_date.date_day` → `fact_orders.order_date`
  - `dim_date.date_day` → `fact_order_items.order_date`
  - `dim_customers.customer_id` → `fact_orders.customer_id`
  - `dim_customers.customer_id` → `fact_order_items.customer_id`
  - `dim_products.product_id` → `fact_order_items.product_id`
  - `dim_sellers.seller_id` → `fact_order_items.seller_id`
  - `fact_orders.order_id` → `fact_order_items.order_id`
- Marquer les dimensions comme tables de référence pour garder un modèle en étoile lisible.

### 3) Publier et rafraîchir dans Power BI Service

1. Publier le rapport vers un workspace.
2. Dans **Settings → Dataset → Data source credentials**, reconnecter BigQuery.
3. Configurer un **Scheduled refresh** (ex. quotidien).

## Workflow

- Transformation des données avec dbt
- Tests de qualité (dbt test)
- Exposition dans BigQuery
- Consommation dans Power BI

Le data warehouse constitue la source unique de vérité

## Bonnes pratiques

- Fichiers sensibles ignorés (.env)
- Artefacts dbt exclus (target/, logs/, dbt_packages/)
- Versioning du code avec Git

## Résultat

Ce projet démontre :
- Mise en place d'un pipeline Analytics Engineering complet
- Modélisation de données avec dbt
- Conception d'un data warehouse
- Création d'un modèle BI performant
- Développement d'un dashboard orienté business
- Application de bonnes pratiques data (tests, versioning, séparation des couches)