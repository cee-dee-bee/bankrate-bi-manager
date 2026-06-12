### Session fact  ###
view: fct_sessions {
  sql_table_name: analytics.sessions ;;

  ### KEYS AND IDS ###
  dimension: session_id {
    primary_key: yes
    group_label: "IDs"
    description: "Source session identifier"
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }

  ### DIMENSIONS ###
  dimension: vertical {
    type: string
    sql: ${TABLE}.vertical ;;
  }

  dimension: content_type {
    type: string
    sql: ${TABLE}.content_type ;;
  }

  dimension_group: session_start {
    type: time
    timeframes: [time, date, week, month, quarter, year]
    sql: ${TABLE}.session_start_time ;;
  }

  ### MEASURES ###
  measure: total_sessions {
    type: count_distinct
    sql: ${session_id} ;;
  }
}
