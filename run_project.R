# -------------------------------
# UNICEF D&A Consultancy Test - Workflow Runner
# -------------------------------


# Load user profile and setup
source(here::here("user_profile.R"))

# Render the final report to 04_outputs/
rmarkdown::render(
  input = here::here("03_notebooks", "final_report.Rmd"),
  output_format = "html_document",
  output_file = here::here("04_outputs", "final_report.html")
)

