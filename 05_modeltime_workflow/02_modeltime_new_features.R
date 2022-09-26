# BUSINESS SCIENCE UNIVERSITY
# DS4B 203-R: TIME SERIES FORECASTING FOR BUSINESS
# MODULE: NEW FEATURES - MODELTIME 0.1.0

# GOAL ----
# Showcase Modeltime's Flexibility 

# OBJECTIVES ----
# - Expedited Forecasting - Skip Calibrating / Refitting
# - Working with In-Sample & Out-of-Sample Data
# - NEW Residual Diagnositics

# LIBRARIES ----

# Time Series ML
library(tidymodels)
library(modeltime)

# Core
library(tidyverse)
library(timetk)
library(lubridate)

# DATA & ARTIFACTS ----

feature_engineering_artifacts_list <- read_rds("00_models/feature_engineering_artifacts_list.rds")

data_prepared_tbl    <- feature_engineering_artifacts_list$data$data_prepared_tbl
forecast_tbl         <- feature_engineering_artifacts_list$data$forecast_tbl
recipe_spec_1_spline <- feature_engineering_artifacts_list$recipes$recipe_spec_1
recipe_spec_2_lag    <- feature_engineering_artifacts_list$recipes$recipe_spec_2

# TRAIN / TEST ----

splits <- data_prepared_tbl %>%
    time_series_split(assess = "8 weeks", cumulative = TRUE)


# 1.0 EXPEDITED FORECASTING ----

# * Model Time Table ----
#   - Fitted on Full Dataset (No Train/Test)

model_fit_prophet <- prophet_reg() %>%
  set_engine("prophet") %>%
  fit(optins_trans ~ optin_time, data = data_prepared_tbl)

model_spec_glmnet <- linear_reg(
  penalty = 0.1,
  mixture = 0.5
  ) %>%
  set_engine("glmnet")

workflow_fit_glmnet <- workflow() %>%
  add_model(model_spec_glmnet) %>%
  add_recipe(recipe_spec_2_lag) %>%
  fit(data_prepared_tbl)


model_tbl <- modeltime_table(
  model_fit_prophet,
  workflow_fit_glmnet,
)

# * Make a Forecast ----
#   - No confidence intervals


# * Visualize a Fitted Model ----




# 2.0 CALIBRATION (In-Sample vs Out-of-Sample) ----

# * Refitting for Train/Test ----


# * Accuracy ----

# Out-of-Sample 


# In-Sample


# 3.0 RESIDUALS ----

# * Time Plot ----

# Out-of-Sample 


# In-Sample



# * ACF Plot ----

# Out-of-Sample 


# In-Sample



# * Seasonality ----

# Out-of-Sample 


# In-Sample



