include: "/views/order_items.view"
view: usecase3 {
  derived_table: {
    explore_source: order_items {
      column: order_sequence {
        field: order_items.order_sequence
      }
      # column: count_user {
      #   field: order_items.count_user
      # }
      column: user_id {
        field: order_items.user_id
      }
    }
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id  ;;
  }
  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence  ;;
  }
  dimension: is_repeat_customer {
    type: yesno
    sql: ${order_sequence}>1 ;;
  }
  measure: count_user {
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }
  # measure: count_repeat_user {
  #   type: count_distinct
  #   sql: ${count_user} ;;
  #   filters: [is_repeat_customer: "Yes"]
  # }

 }
