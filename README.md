# Ecommerce Data Warehouse with dbt

Projet d’Analytics Engineering construit avec **dbt** pour transformer des données e-commerce brutes en un modèle analytique exploitable (dimensions + faits) dans un data warehouse.

## Objectifs

- Construire une couche analytique fiable pour le suivi business e-commerce.
- Standardiser les transformations avec dbt (SQL versionné, tests, lineage).
- Exposer des tables marts prêtes pour le reporting BI.

## Stack

- dbt Core
- SQL (models staging / intermediate / marts)
- Data warehouse (profil dbt configuré localement)

## Architecture du projet

Le code dbt se trouve dans le dossier `ecommerce_project_ae/` :

- `models/intermediate/` : enrichissements intermédiaires
- `models/marts/core/` : tables analytiques finales
  - `fact_orders`
  - `fact_order_items`
  - `dim_customers`
  - `dim_products`
  - `dim_sellers`
  - `dim_date`

## Modèle de données (vue d’ensemble)

- **Faits**
  - `fact_orders` : métriques au niveau commande (revenu, fret, délai de livraison, etc.)
  - `fact_order_items` : détails au niveau ligne de commande
- **Dimensions**
  - `dim_customers` : informations clients
  - `dim_products` : informations produits et catégorie
  - `dim_sellers` : informations vendeurs
  - `dim_date` : calendrier analytique (jour, semaine, mois, trimestre, année)

## Tests de qualité

Le projet inclut des tests dbt sur les tables de marts :

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

### 4) Workflow recommandé

- Exécuter `dbt run` et `dbt test` avant chaque rafraîchissement BI important.
- Utiliser les tables **marts** comme source unique du rapport ; les mesures et maquettes détaillées restent dans l’outil BI (hors dépôt).
