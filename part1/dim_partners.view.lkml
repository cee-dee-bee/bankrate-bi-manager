### Partner dimensions ###
view: dim_partners {
  sql_table_name: analytics.partners ;;

  ### KEYS ###
  dimension: partner_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.partner_id ;;
  }

  ### DIMENSIONS ###
  dimension: partner_name {
    type: string
    sql: ${TABLE}.partner_name ;;
  }

  dimension: vertical {
    type: string
    sql: ${TABLE}.vertical ;;
  }
}
