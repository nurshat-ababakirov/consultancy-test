# -------------------------------
# 02_calc_weighted_coverage.R - Weighted Coverage Calculation
# -------------------------------

# 1. Load libraries and user profile
source(here::here("user_profile.R"))

# 2. Load cleaned and merged dataset
merged_df <- read_csv(PATHS$processed %>% file.path("merged_health_data.csv")) %>%
  clean_names()

# 3. Check structure (optional)
glimpse(merged_df)

# 4. Calculate population-weighted ANC4 and SBA coverage
weighted_df <- merged_df %>%
  filter(
    !is.na(track_status),
    !is.na(anc4),
    !is.na(sba),
    !is.na(births)
  ) %>%
  group_by(track_status) %>%
  summarise(
    weighted_anc4 = weighted.mean(anc4, w = births, na.rm = TRUE),
    weighted_sba  = weighted.mean(sba,  w = births, na.rm = TRUE),
    total_births  = sum(births, na.rm = TRUE),
    .groups = "drop"
  )

# 5. Calculate differences between on-track and off-track
diff_row <- tibble(
  track_status = "Difference (off - on)",
  weighted_anc4 = weighted_df$weighted_anc4[weighted_df$track_status == "off-track"] - 
  weighted_df$weighted_anc4[weighted_df$track_status == "on-track"],
  weighted_sba = weighted_df$weighted_sba[weighted_df$track_status == "off-track"] -
     weighted_df$weighted_sba[weighted_df$track_status == "on-track"],
  total_births  = NA  # Not meaningful to compare total_births
)

# 6. Combine original and difference
weighted_df_final <- bind_rows(weighted_df, diff_row)

# 7. View result
print(weighted_df_final)

# 8. Save result (optional)
write_csv(weighted_df_final, file = file.path(PATHS$processed, "population_weighted_coverage_by_track_status.csv"))

message("Population-weighted coverage calculation complete.")