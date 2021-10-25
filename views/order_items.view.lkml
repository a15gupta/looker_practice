view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS";;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: is_cancelled_returned {
    type:  yesno
    sql: ${status} = 'Cancelled' or ${status} = 'Returned' ;;
  }

  dimension: is_returned {
    type: yesno
    sql: ${returned_raw} is not null ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  ########created

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: cumulative_total_sale {
    type: running_total
    sql: ${total_gross_revenue} ;;
    value_format_name: usd
  }

  measure: total_gross_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: [is_cancelled_returned: "No"]
    value_format_name: usd
    drill_fields: [
      products.brand,
      products.category,
      products.name
      ]
  }

  measure: average_gross_revenue {
    type: average
    sql: ${sale_price} ;;
    filters: [is_cancelled_returned: "No"]
    value_format_name: usd
  }

  measure: MTD_Total_Revenue {
    type:  sum
    sql: ${sale_price} ;;

  }

  measure: total_gross_margin_amount {
    type: number
    sql: ${total_gross_revenue} - ${inventory_items.total_cost};;
    value_format_name: usd
  }

  measure: average_gross_margin {
    type: number
    sql:  ${average_gross_revenue}-${average_sale_price};;
    value_format_name: usd
    #filters: [is_cancelled_returned: "No"]
  }

  measure: gross_margin_per {
    type: number
    sql: ${total_gross_margin_amount}/NULLIF(${total_gross_revenue},0) ;;
    value_format_name: percent_1
  }

  measure: count_returned_items {
    type: count_distinct
    sql: ${id};;
    filters: [is_returned: "Yes"]
  }

  measure: item_return_rate {
    type: number
    sql: ${count_returned_items}/${count} ;;
    value_format_name: percent_1
  }

  measure: count_users_returning_items {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [is_returned: "Yes"]
  }

  measure: count_user {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: returned_users_per {
    type: number
    sql: 1.0*(${count_users_returning_items})/NULLIF( ${count_user},0);;
  }

  measure: average_spend_per_customer {
    type: number
    sql: 1.0*(${total_sale_price})/NULLIF(${count_user},0) ;;
    value_format_name: usd
    drill_fields: [user_id,users.age_tier,users.age,users.gender]
  }

  measure: order_count {
    type: count_distinct
    sql: ${id} ;;
  }

  measure: first_order {
    type: date
    sql: min(${created_raw}) ;;
  }

  measure: last_order {
    type: date
    sql: max(${created_raw}) ;;
  }

  #####end

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.id,
      users.first_name
    ]
  }
}
