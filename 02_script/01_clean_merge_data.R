# Load libraries
library(tidyverse)
library(readxl)
library(janitor)
library(countrycode)


# Set paths
raw_dir <- "01_data/raw"
proc_dir <- "01_data/processed"

# 1. Load On-track / Off-track classification
status_df <- read_excel(file.path(raw_dir, "On-track and off-track countries.xlsx")) %>%
  clean_names() %>%
  rename(
    iso3 = iso3code,
    country = official_name
  ) %>%
  mutate(
    track_status = case_when(
      status_u5mr %in% c("Achieved", "On Track") ~ "on-track",
      status_u5mr == "Acceleration Needed" ~ "off-track",
      TRUE ~ NA_character_
    )
  )

# 2. Load births from WPP2022 from the Projections sheet
wpp_df <- read_excel(
  path = file.path(raw_dir, "WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx"),
  sheet = "Projections", 
  skip = 16
) %>%
  clean_names() %>%
  rename(country = region_subregion_country_or_area) %>%
  filter(year == 2022, variant == "Medium") %>%
  filter(
    !str_detect(country, "World|regions|income|Africa|Asia|Europe|America|Oceania|Union|UN|development")
  ) %>% 
  select(country, births_1000s = births_thousands) %>%
  mutate(births = as.numeric(births_1000s) * 1000,
         iso3 = countrycode(country, "country.name", "iso3c")) %>% 
  filter(!is.na(iso3))


# 3. Load ANC4 and SBA indicators with country filtering
df_health <- read_excel(file.path(raw_dir, "GLOBAL_DATAFLOW_2018-2022.xlsx")) %>%
  clean_names() %>%
  filter(
    indicator %in% c(
      "Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider",
      "Skilled birth attendant - percentage of deliveries attended by skilled health personnel"
    ),
    !is.na(obs_value)
  ) %>%
  mutate(
    iso3 = countrycode(geographic_area, "country.name", "iso3c")
  ) %>%
  filter(!is.na(iso3)) %>%  # drop regions and unmapped names
  mutate(
    country = geographic_area
  ) %>% 
  group_by(iso3, country, indicator) %>%
  summarise(value = mean(as.numeric(obs_value), na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(
    names_from = indicator,
    values_from = value
  ) %>%
  rename(
    anc4 = `Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider`,
    sba  = `Skilled birth attendant - percentage of deliveries attended by skilled health personnel`
  )

# 4. Merge all
merged_df <- df_health %>%
  left_join(status_df, by = "iso3") %>%
  left_join(wpp_df, by = "iso3") %>%
  mutate(country = coalesce(country.y, country.x, country)) %>% 
  select(iso3, country, track_status, anc4, sba, births) %>% 
  filter(
    !is.na(track_status),
    !is.na(births),
    !is.na(anc4),
    !is.na(sba)
  )

# 5. Save
write_csv(merged_df, file.path(proc_dir, "merged_health_data.csv"))
