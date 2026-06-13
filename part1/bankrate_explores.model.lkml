# bankrate.model
connection: "bankrate_databricks"
include: "/part1/*.view.lkml" 

label: Bankrate product revenue explore

# explore focused on revenue and related dimensions
explore: fct_revenue {
  label: "Revenue"
  description: "Revenue by partner, product, and date."
  join: dim_partners {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_revenue.partner_id} = ${dim_partners.partner_id} ;;
  }
}
