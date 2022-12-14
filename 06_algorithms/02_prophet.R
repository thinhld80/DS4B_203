# BUSINESS SCIENCE UNIVERSITY
# DS4B 203-R: TIME SERIES FORECASTING FOR BUSINESS
# MODULE: PROPHET

# GOAL: Understand PROPHET

# OBJECTIVES ----
# - Describe PROPHET using Prophet Components
# - Inspect Key Parameters
# - Show Modeltime PROPHET

# LIBRARIES & SETUP ----

# Time Series ML
library(tidymodels)
library(modeltime)
library(prophet)

# Core 
library(tidyverse)
library(lubridate)
library(timetk)
library(plotly)

# DATA ----

artifacts_list <- read_rds("00_models/feature_engineering_artifacts_list.rds") 
data_prepared_tbl <- artifacts_list$data$data_prepared_tbl 

data_prepared_tbl

# TRAIN / TEST SPLITS ----

splits <- time_series_split(data_prepared_tbl, assess = "8 weeks", cumulative = TRUE)

splits %>%
    tk_time_series_cv_plan() %>%
    plot_time_series_cv_plan(optin_time, optins_trans)


# 1.0 PROPHET MODEL ----

# * Modeltime Model ----

?prophet_reg

model_fit_prophet <- prophet_reg(
  changepoint_num    = 10,
  changepoint_range  = 0.2,
  seasonality_yearly = FALSE
) %>%
  set_engine("prophet") %>%
  fit(optins_trans ~ optin_time, data = training(splits))

modeltime_table(model_fit_prophet) %>%
  modeltime_calibrate(new_data = testing(splits)) %>%
  modeltime_forecast(
    new_data    = testing(splits),
    actual_data = data_prepared_tbl
  ) %>%
  plot_modeltime_forecast()

# 2.0 PROPHET CONCEPTS ----

# * Extract model ----



# * Visualize prophet model ----



# * Visualize Additive Components ----



# 3.0 XREGS ----

# * Model ----



# * Calibration ----



# * Forecast Test ----



# * Accuracy Test ----



# * Refit ----

