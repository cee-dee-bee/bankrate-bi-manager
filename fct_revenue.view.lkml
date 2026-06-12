### Combined view of revenue for all products ###
view: fct_revenue {
  sql_table_name: analytics.fct_revenue ;;

  ### KEYS AND IDS  ###
  dimension: revenue_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.revenue_key ;;
  }  

  dimension: application_id {
    group_label: "IDs"
    description: "Source application identifier for non-mortgage revenue. NULL for mortgage revenue."
    type: string
    sql: ${TABLE}.application_id ;;
  }
  
  dimension: clickout_id {
    group_label: "IDs"
    description: "Source clickout identifier for mortgage revenue."
    type: string
    sql: ${TABLE}.clickout_id ;;
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
  
  dimension_group: revenue {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.revenue_date ;;
  }

  ### MEASURES ###
  measure: total_revenue {
    type: sum
    value_format_name: usd
    sql: ${TABLE}.revenue_amount ;;
  }
  
  measure: avg_revenue {
    type: avg
    value_format_name: usd
    sql: ${TABLE}.revenue_amount ;;
  }
}
