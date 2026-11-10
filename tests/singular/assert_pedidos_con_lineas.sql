select
    o.order_id
from {{ ref('fct_orders') }} as o
left join {{ ref('fct_order_items') }} as i
    on o.order_id = i.order_id
where i.order_id is null