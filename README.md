# Ecommerce Data Warehouse with dbt

Projet d'Analytics Engineering construit avec **dbt** pour transformer des donnees e-commerce brutes en un modele analytique exploitable (dimensions + faits) dans un data warehouse.

## Objectifs

- Construire une couche analytique fiable pour le suivi business e-commerce.
- Standardiser les transformations avec dbt (SQL versionne, tests, lineage).
- Exposer des tables marts prêtes pour le reporting BI.

## Stack

- dbt Core
- SQL (models staging/intermediate/marts)
- Data warehouse (profil dbt configure localement)

## Architecture du projet

Le code dbt se trouve dans le dossier `ecommerce_project_ae/` :

- `models/intermediate/` : enrichissements intermediaires
- `models/marts/core/` : tables analytiques finales
  - `fact_orders`
  - `fact_order_items`
  - `dim_customers`
  - `dim_products`
  - `dim_sellers`

## Data model (high level)

- **Facts**
  - `fact_orders` : metriques au niveau commande (revenu, fret, delai de livraison, etc.)
  - `fact_order_items` : details au niveau item de commande
- **Dimensions**
  - `dim_customers` : informations clients
  - `dim_products` : informations produits et categorie
  - `dim_sellers` : informations vendeurs

## Tests de qualite

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

- Les fichiers sensibles (ex: `.env`) sont ignores.
- Les artefacts dbt (`target/`, `logs/`, `dbt_packages/`) sont ignores.

## Auteur

Pedro Rodrigues Gaspar
