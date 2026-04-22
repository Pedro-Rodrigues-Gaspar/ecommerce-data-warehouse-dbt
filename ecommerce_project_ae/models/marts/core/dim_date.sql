{{ config(materialized='table') }}

with date_spine as (

    select date_day
    from unnest(
        generate_date_array(date('2016-01-01'), date('2018-12-31'), interval 1 day)
    ) as date_day

)

select
    date_day,
    extract(year from date_day) as year,
    extract(quarter from date_day) as quarter,
    extract(month from date_day) as month_number,
    format_date('%B', date_day) as month_name,
    format_date('%Y-%m', date_day) as year_month,
    extract(week from date_day) as week_of_year,
    extract(dayofweek from date_day) as day_of_week,
    format_date('%A', date_day) as day_name
from date_spine