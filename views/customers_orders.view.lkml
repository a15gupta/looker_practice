include: "/models/*.lkml"
view: customers_orders {
  derived_table: {
    explore_source: order_items{
      column: user_id {
        field: order_items.user_id
      }
      column: lifetime_orders {
        field: order_items.count
      }
      column: lifetime_value {
        field: order_items.total_sale_price
      }
      column: first_order {
        field: order_items.first_order
      }
      column: last_order {
        field: order_items.last_order
      }
      column: lifetime_revenue {
        field: order_items.total_gross_revenue
      }
    }
    }
    dimension: user_id {
      type: number
      primary_key: yes
      sql: ${TABLE}.user_id ;;
    }

    dimension: total_lifetime_orders {
      type: number
      sql: ${TABLE}.lifetime_orders  ;;
    }

    dimension: lifetime_orders_tier {
      type: bin
      tiers: [1,2,3,6,10]
      sql: ${total_lifetime_orders} ;;
      style: integer
    }

    dimension: total_lifetime_value {
      type: number
      sql: ${TABLE}.lifetime_value  ;;
    }

    dimension: lifetime_value_tier {
      type: tier
      tiers: [0,5,20,50,100,500,1000]
      sql: ${total_lifetime_revenue} ;;
      style: integer
      value_format_name: usd
    }

  dimension: total_lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue  ;;
  }

    dimension: first_order {
      type:  date
      sql: ${TABLE}.first_order  ;;
    }

    dimension: last_order {
      type:  date
      sql: ${TABLE}.last_order  ;;
    }

    dimension_group: since_last_purchase {
      type: duration
      sql_start: ${last_order} ;;
      sql_end: current_timestamp() ;;
      intervals: [day]
    }

    dimension: is_repeat_customer {
      type:  yesno
      sql: ${total_lifetime_orders}>1 ;;
    }

    dimension: is_active {
      type: yesno
      sql: ${days_since_last_purchase} < 90 ;;
    }

    measure: count {
      type: count
    }

    measure: unique_users{
      type: count_distinct
      sql: ${user_id} ;;
    }

    measure: average_lifetime_orders {
      type: number
      sql: SUM(${total_lifetime_orders})/${unique_users} ;;
      value_format_name: usd
    }

    measure: average_lifetime_revenue {
      type: number
      sql: SUM(${total_lifetime_revenue})/${unique_users} ;;
      value_format_name: usd
    }

    measure: average_days_since_last_order {
      type: number
      sql: SUM(${days_since_last_purchase})/ ${unique_users};;
    }

  }
