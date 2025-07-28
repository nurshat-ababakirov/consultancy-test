# -------------------------------
# user_profile.R - Project Environment Setup
# -------------------------------

# 1. Helper: Install & load required packages
ensure_packages <- function(pkgs) {
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg, repos = "https://cloud.r-project.org", dependencies = TRUE)
    }
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
}

# 2. Define required packages
required_packages <- c(
  "tidyverse",     # includes dplyr, readr, ggplot2, tidyr, etc.
  "readxl",        # read Excel files
  "janitor",       # clean_names()
  "here",          # portable paths
  "rmarkdown",     # render reports
  "knitr",         # knit reports
  "glue",          # string interpolation
  "countrycode",   # map country names <-> ISO3
  "sessioninfo"  # for reproducibility
)

ensure_packages(required_packages)

# 3. Global options
options(
  stringsAsFactors = FALSE,
  scipen = 999
)

# 4. Define project root and paths
project_root <- here::here()

PATHS <- list(
  raw_data   = here("01_data", "raw"),
  processed  = here("01_data", "processed"),
  scripts    = here("02_script"),
  notebooks  = here("03_notebooks"),
  outputs    = here("04_outputs")
)

# 5. Create folders if missing
invisible(lapply(PATHS, function(p) if (!dir.exists(p)) dir.create(p, recursive = TRUE)))

# 6. Confirm setup
message("Environment setup complete.\n Root: ", project_root)
sessioninfo::session_info()
