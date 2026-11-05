-- dim_users
-- Dimensión de usuarios, con país y continente sacados de dim_addresses.
-- Grano: una fila por usuario.

with users as (
    select * from {{ ref('slv_sql_server_dbo__users') }}
),

addresses as (
    select * from {{ ref('dim_addresses') }}
),

final as (
    select
          u.user_id
        , u.first_name
        , u.last_name
        , u.first_name || ' ' || u.last_name       as full_name
        , u.email
        , u.is_valid_email_address
        , u.phone_number
        , u.address_id
        , a.state
        , a.country
        , a.country_code
        , a.continent
        , u.created_at_utc                         as registered_at_utc
        , u.updated_at_utc
        , u.date_load
    from users u
    left join addresses a on u.address_id = a.address_id
)

select * from final
