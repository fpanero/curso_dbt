-- int_orders__enriched
-- Une cada pedido con su dirección de envío y su promo. Grano: una fila por pedido.
-- Se materializa como vista (lo marca dbt_project.yml para gold/intermediate).

with orders as (
    select * from {{ ref('slv_sql_server_dbo__orders') }}
),

addresses as (
    select * from {{ ref('slv_sql_server_dbo__addresses') }}
),

promos as (
    select * from {{ ref('slv_sql_server_dbo__promos') }}
),

enriched as (
    select
          o.order_id
        , o.user_id
        , o.address_id
        , a.address_line
        , a.zipcode
        , a.state
        , a.country
        , o.promo_id
        , p.promo_status
        , coalesce(p.discount_usd, 0)                          as discount_usd
        , o.created_at_utc
        , o.estimated_delivery_at_utc
        , o.delivered_at_utc
        , o.tracking_id
        , o.shipping_service
        , o.shipping_cost_usd
        , o.order_cost_usd
        , o.total_order_cost_usd
        , o.total_order_cost_usd - coalesce(p.discount_usd, 0) as net_order_cost_usd
        , o.order_status
        , o.date_load
    from orders o
    left join addresses a on o.address_id = a.address_id   -- left: no perder pedidos
    left join promos    p on o.promo_id   = p.promo_id     -- left: la mayoría no tiene promo
)

select * from enriched