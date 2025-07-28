# 📊 UNICEF D&A Consultancy Test

This repository contains the full analytical workflow for the UNICEF Data and Analytics (D&A) Consultancy technical test. 
The goal of the project is to calculate **population-weighted coverage of maternal health indicators**—specifically:

- **ANC4**: Percentage of women receiving 4+ antenatal care visits
- **SBA**: Percentage of births attended by skilled health personnel

These indicators are compared between **on-track** and **off-track** countries, based on under-five mortality rate (U5MR) classifications. 
The results are visualized and interpreted in a final report.

---

## 📁 Folder Structure

```
UNICEF-Consultancy-Assessment/
├── 01_data/
│   ├── raw/               # Raw data files (manually downloaded or provided)
│   └── processed/         # Cleaned and merged datasets
├── 02_scripts/            # Scripts for data cleaning and analysis
├── 03_notebooks/          # R Markdown report generation
├── 04_outputs/            # Final HTML report and tables/figures
├── user_profile.R         # Paths and environment setup
├── run_project.R          # Executes full workflow and renders the report
├── README.md              # Project overview and reproduction instructions
```

---

## 📥 Data Sources

### 1. **Health Coverage Indicators (ANC4 and SBA)**
- **Source**: UNICEF Global Databases  
- **File**: `GLOBAL_DATAFLOW_2018-2022.xlsx`  
- **Format**: Long format  
- **Access**: [UNICEF Data Portal – Health Coverage Indicators](https://data.unicef.org/resources/data_explorer/unicef_f/?ag=UNICEF&df=GLOBAL_DATAFLOW&ver=1.0&dq=.MNCH_ANC4+MNCH_SAB.&startPeriod=2018&endPeriod=2022)  
- **Note**: This file was **manually downloaded** in long format and placed in `01_data/raw/`.

### 2. **Under-Five Mortality Classification**
- **Source**: UNICEF-supplied spreadsheet  
- **File**: `On-track and off-track countries.xlsx`  
- **Note**: Used to classify countries as on-track or off-track for U5MR targets.

### 3. **Births (2022 Projections)**
- **Source**: UN World Population Prospects (WPP2022)  
- **File**: `WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx`  
- **Sheet**: `Projections`  
- **Note**: Used to weight health coverage indicators by projected number of births.

---

## 🔁 Reproducibility

To run this project end-to-end:

1. Clone the repository.
2. Ensure all required R packages are installed. Use the `user_profile.R` script to set up folders and packages.
3. Place the raw data files in the `01_data/raw/` directory. The health coverage Excel file must be downloaded manually due to data portal restrictions.
4. Run the workflow by executing:

```r
source("run_project.R")
```

This script will:

- Load and clean all data
- Merge datasets by ISO3 country codes
- Calculate weighted averages by track status
- Render an HTML report into `04_outputs/final_report.html`

---

## 📑 Output

The final report includes:

- ✅ A **styled table** comparing ANC4 and SBA coverage by track status  
- 📊 A **bar chart** visualizing disparities in maternal health coverage  
- 🧾 A **short interpretive summary** outlining findings, caveats, and limitations

---

## 🛠 Dependencies

- **R version**: ≥ 4.0
- **Key packages**:  
  `tidyverse`, `readxl`, `countrycode`, `janitor`, `knitr`, `kableExtra`, `rmarkdown`, `here`
- **Optional**: `tinytex` (if rendering to PDF)

---

## 🔗 License & Acknowledgement
This project is part of a technical assessment and is not intended for public use or redistribution. 
All data used herein remain the property of their original custodians. 

## Positions Applied
- Learning and Skills Data Analyst Consultant – Req. #581598
- Household Survey Data Analyst Consultant – Req. #581656
- Administrative Data Analyst – Req. #581696
- Microdata Harmonization Consultant – Req. #581699

This project is part of a technical assessment and is not intended for public use or redistribution. All data used herein remain the property of their original custodians (UNICEF, UN DESA).