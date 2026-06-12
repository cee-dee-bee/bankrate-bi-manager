### User dimensions ###
view: dim_users {
  sql_table_name: analytics.users ;;

  ### KEYS ###
  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }

  ### DIMENSIONS ###
  dimension: acquisition_channel {
    type: string
    sql: ${TABLE}.acquisition_channel ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension_group: first_seen {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.first_seen_date ;;
  }
}
