-- fct_orders
-- Hechos de pedidos. Grano: una fila por pedido.
-- Los nombres de columna los usa agg_user_purchases (parte_b): no cambiarlos.

with orders as (
    select * from {{ ref('int_orders__enriched') }}
),

final as (
    select
          order_id
        , user_id
        , address_id
        , promo_id
        , country                                  as shipping_country
        , created_at_utc                           as order_created_at_utc
        , estimated_delivery_at_utc
        , delivered_at_utc
        , datediff('day', created_at_utc, delivered_at_utc) as delivery_days
        , shipping_service
        , shipping_cost_usd
        , order_cost_usd
        , total_order_cost_usd
        , discount_usd
        , net_order_cost_usd
        , order_status
        , delivered_at_utc is not null              as is_delivered
        , date_load
    from orders
)

select * from final