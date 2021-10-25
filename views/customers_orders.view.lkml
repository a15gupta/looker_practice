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
    }
    }
    dimension: user_id {
      type: number
      primary_key: yes
      sql: ${TABLE}.user_id ;;
    }

    dimension: lifetime_orders {
      type: number
      sql: ${TABLE}.lifetime_orders  ;;
    }

    dimension: lifetime_value {
      type: number
      sql: ${TABLE}.lifetime_value  ;;
    }

    dimension: first_order {
      type:  date
      sql: ${TABLE}.first_order  ;;
    }

    dimension: last_order {
      type:  date
      sql: ${TABLE}.last_order  ;;
    }

  }
