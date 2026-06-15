with customers as (
    select
        id          as customer_id,
        first_name,
        last_name
    from {{ source('raw', 'raw_customers') }}
),

orders as (
    select
        id          as order_id,
        user_id     as customer_id,
        order_date,
        status
    from {{ source('raw', 'raw_orders') }}
),

payments as (
    select
        id          as payment_id,
        order_id,
        amount
    from {{ source('raw', 'raw_payments') }}
),

order_payments as (
    select
        order_id,
        sum(amount) as total_amount
    from payments
    group by order_id
),

final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        min(o.order_date)                  as first_order,
        max(o.order_date)                  as most_recent_order,
        count(distinct o.order_id)         as number_of_orders,
        coalesce(sum(op.total_amount), 0)  as customer_lifetime_value
    from customers c
    left join orders o          on c.customer_id = o.customer_id
    left join order_payments op on o.order_id    = op.order_id
    group by 1, 2, 3
)

select * from final
