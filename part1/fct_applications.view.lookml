### Application fact for non-mortgage products ###
view: fct_applications {
  sql_table_name: analytics.applications ;;

  ### KEYS AND IDS ###
  dimension: application_id {
    primary_key: yes
    group_label: "IDs"
    description: "Source application (non-mortgage)"
    type: string
    sql: ${TABLE}.application_id ;;
  }

  dimension: clickout_id {
    group_label: "IDs"
    description: "Source clickout for application"
    type: string
    sql: ${TABLE}.clickout_id ;;
  }

  dimension: partner_id {
    hidden: yes
    type: string
    sql: ${TABLE}.partner_id ;;
  }

  ### DIMENSIONS ###
  dimension: reason {
    label: "Loan Purpose"
    type: string
    sql: ${TABLE}.reason ;;
  }

  dimension: fico_score_group {
    type: string
    sql: ${TABLE}.fico_score_group ;;
  }

  dimension: employment_status {
    type: string
    sql: ${TABLE}.employment_status ;;
  }

  dimension: employment_sector {
    type: string
    sql: ${TABLE}.employment_sector ;;
  }

  dimension: ever_bankrupt_or_foreclose {
    label: "Ever Bankrupt or Foreclosed"
    type: yesno
    sql: ${TABLE}.ever_bankrupt_or_foreclose = 1 ;;
  }

  dimension: loan_amount {
    type: number
    value_format_name: usd
    sql: ${TABLE}.loan_amount ;;
  }

  # The following dimensions are abstracted from users due to sensitivity, but access can be permissioned
  dimension: fico_score {
    hidden: yes
    type: number
    sql: ${TABLE}.fico_score ;;
  }

  dimension: monthly_gross_income {
    hidden: yes
    type: number
    sql: ${TABLE}.monthly_gross_income ;;
  }

  dimension: monthly_housing_payment {
    hidden: yes
    type: number
    sql: ${TABLE}.monthly_housing_payment ;;
  }

# Recast 1/0 status into Approved and Declined classification
  dimension: application_status {
    label: "Application Status"
    type: string
    sql: CASE
           WHEN ${TABLE}.application_status = 1 THEN 'Approved'
           WHEN ${TABLE}.application_status = 0 THEN 'Declined'
           ELSE 'Unknown'
         END ;;
  }

  ### MEASURES ###
  measure: total_applications {
    type: count_distinct
    sql: ${application_id} ;;
  }

  measure: total_approvals {
    type: count_distinct
    sql: ${application_id} ;;
    filters: [application_status: "Approved"]
  }

  measure: total_declines {
    type: count_distinct
    sql: ${application_id} ;;
      filters: [application_status: "Declined"]
  }

  measure: approval_rate {
    description: "Approvals / Applications"
    type: number
    value_format_name: percent_1
    sql: ${total_approvals} / NULLIF(${total_applications}, 0) ;;
  }

  measure: avg_loan_amount {
    type: average
    value_format_name: usd
    sql: ${TABLE}.loan_amount ;;
  }
}
