connection: "bankrate_databricks"
include: "/part1/*.view.lkml" 

label: "Bankrate Business Intelligence Assessment Model" 

### revenue explore and related application, clickout, partner, and user dimensions ###
explore: fct_revenue {
  label: "Revenue"
  description: "Revenue by partner, product, and date."

  ### non-mortgage application dimensions ###
  join: fct_applications {
    type: left_outer
    relationship: one_to_one
    sql_on: ${fct_revenue.application_id} = ${fct_applications.application_id} ;;
    fields: [
      fct_applications.reason,
      fct_applications.loan_amount,
      fct_applications.fico_score_group,
      fct_applications.employment_status,
      fct_applications.employment_sector,
      fct_applications.ever_bankrupt_or_foreclose
    ]
  }

  ### clickout dimensions for both mortgage and non-mortgage products ###
  join: fct_clickouts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${fct_revenue.clickout_id} = ${fct_clickouts.clickout_id} ;;
    fields: [
      fct_clickouts.apr,
      fct_clickouts.fees
    ]
  }

  ### partner dimensions ###
  join: dim_partners {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_revenue.partner_id} = ${dim_partners.partner_id} ;;
  }

  ### user dimensions ###
  join: dim_users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_clickouts.user_id} = ${dim_users.user_id} ;;
    fields: [
      dim_users.acquisition_channel,
      dim_users.device_type
    ]
  }
}
