# dbt Project - ecommerce_project_ae

Ce dossier contient le projet dbt principal de ce repository.

## Commandes utiles

```bash
dbt run
dbt test
dbt docs generate
dbt docs serve
```

## Modeles principaux

- `models/marts/core/fact_orders.sql`
- `models/marts/core/fact_order_items.sql`
- `models/marts/core/dim_customers.sql`
- `models/marts/core/dim_products.sql`
- `models/marts/core/dim_sellers.sql`
