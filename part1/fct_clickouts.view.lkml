### Clickouts for all products ###
view: fct_clickouts {
  sql_table_name: analytics.fct_clickouts ;;

  ### KEYS AND IDS ###
  dimension: clickout_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.clickout_key ;;
  }

  dimension: clickout_id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.clickout_id ;;
  }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: partner_id {
    hidden: yes
    type: string
    sql: ${TABLE}.partner_id ;;
  }

  ### DIMENSIONS ###
  dimension: product_type {
    label: "Product"
    type: string
    sql: ${TABLE}.product_type ;;
  }

  dimension: is_mortgage {
    type: yesno
    sql: ${TABLE}.product_type = 'mortgage' ;;
  }

  dimension: apr {
    description: "APR for mortgage product"
    type: number
    sql: ${TABLE}.apr ;;
  }

  dimension: fees {
    description: "Fees for mortgage product"
    type: number
    value_format_name: usd
    sql: ${TABLE}.fees ;;
  }

  dimension_group: clickout {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.clickout_time ;;
  }

  ### MEASURES ###
  measure: total_clickouts {
    type: count_distinct
    sql: ${clickout_key} ;;
  }     

  measure: avg_apr {
    type: avg
    sql: ${apr} ;;
  }

  measure: avg_fees {
    type: avg
    sql: ${fees} ;;
  }
}
