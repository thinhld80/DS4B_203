# BUSINESS SCIENCE UNIVERSITY
# DS4B 203-R: TIME SERIES FORECASTING FOR BUSINESS
# MODULE: ADVANCED FEATURE ENGINEERING

# GOALS ----
# - LEARN ADVANCED FEATURE ENGINEERING TECHNIQUES & WORKFLOW

# OBJECTIVES ----
# - IMPLEMENT RECIPES PIPELINE
# - APPLY MODELTIME WORKFLOW & VISUALIZE RESULTS
# - COMPARE SPLINE MODEL VS LAG MODEL

# LIBRARIES & DATA ----

# Time Series ML
library(tidymodels)
library(modeltime)

# Core
library(tidyverse)
library(lubridate)
library(timetk)

# Data
subscribers_tbl   <- read_rds("00_data/mailchimp_users.rds")
learning_labs_tbl <- read_rds("00_data/learning_labs.rds") 

# Data Wrangle
subscribers_prep_tbl <- subscribers_tbl %>%
    summarise_by_time(optin_time, .by = "day", optins = n()) %>%
    pad_by_time(.pad_value = 0)
subscribers_prep_tbl

learning_labs_prep_tbl <- learning_labs_tbl %>%
    mutate(event_date = ymd_hms(event_date)) %>%
    summarise_by_time(event_date, .by = "day", event = n())
learning_labs_prep_tbl

# Data Transformation
subscribers_transformed_tbl <- subscribers_prep_tbl %>%
    
    # Preprocess Target
    mutate(optins_trans = log_interval_vec(optins, limit_lower = 0, offset = 1)) %>%
    mutate(optins_trans = standardize_vec(optins_trans)) %>%
    select(-optins) %>%
    
    # Fix missing values at beginning of series
    filter_by_time(.start_date = "2018-07-03") %>%
    
    # Cleaning
    mutate(optins_trans_cleaned = ts_clean_vec(optins_trans, period = 7)) %>%
    mutate(optins_trans = ifelse(optin_time %>% between_time("2018-11-18", "2018-11-20"), 
                                 optins_trans_cleaned,
                                 optins_trans)) %>%
    select(-optins_trans_cleaned)

subscribers_transformed_tbl


# Save Key Params
limit_lower <- 0
limit_upper <- 3650.8
offset      <- 1
std_mean    <- -5.25529020756467
std_sd      <- 1.1109817111334

# 1.0 STEP 1 - CREATE FULL DATA SET ----
# - Extend to Future Window
# - Add any lags to full dataset
# - Add any external regressors to full dataset

horizon <- 8 * 7
lag_period <- 56
rolling_periods <- c(30, 60, 90) 

subscribers_transformed_tbl

data_prepared_full_tbl <- subscribers_transformed_tbl %>%
  bind_rows(
    future_frame(.data = ., .date_var = optin_time, .length_out = horizon)
  ) %>%
  
  # Add Autocorrelated Lags
  tk_augment_lags(optins_trans, .lags = lag_period) %>%
  
  # Add Rolling Features
  tk_augment_slidify(
    .value   = optins_trans_lag56,
    .f       = mean,
    .period  = rolling_periods,
    .align   = "center",
    .partial = TRUE
      ) %>%
  
  # Add Events
  left_join(learning_labs_prep_tbl, by = c("optin_time" = "event_date")) %>%
  mutate(event = ifelse(is.na(event), 0, event)) %>%
  
  # Format Columns
  rename(lab_event = event) %>%
  rename_with(.fn = ~str_c("lag_", .), .cols = contains("lag"))



data_prepared_full_tbl %>%
  pivot_longer(-optin_time) %>%
  plot_time_series(optin_time, value, name, .smooth = FALSE)


data_prepared_full_tbl %>% tail(8 * 7 + 1)

# 2.0 STEP 2 - SEPARATE INTO MODELING & FORECAST DATA ----

data_prepared_full_tbl %>% tail(57)
  
data_prepared_tbl <- data_prepared_full_tbl %>%
  filter(!is.na(optins_trans))
data_prepared_tbl

forecast_tbl <- data_prepared_full_tbl %>%
  filter(is.na(optins_trans))

forecast_tbl

# 3.0 TRAIN/TEST (MODEL DATASET) ----

splits <- data_prepared_tbl %>% time_series_split(assess = horizon, cumulative = TRUE)

splits %>%
  tk_time_series_cv_plan() %>%
  plot_time_series_cv_plan(optin_time, optins_trans)



# 4.0 RECIPES ----
# - Time Series Signature - Adds bulk time-based features
# - Spline Transformation to index.num
# - Interaction: wday.lbl:week2
# - Fourier Features



# 5.0 SPLINE MODEL ----

# * LM Model Spec ----


# * Spline Recipe Spec ----


# * Spline Workflow  ----


# 6.0 MODELTIME  ----



# 7.0 LAG MODEL ----

# * Lag Recipe ----


# * Lag Workflow ----


# * Compare with Modeltime -----



# 8.0 FUTURE FORECAST ----



# 9.0 SAVE ARTIFACTS ----




