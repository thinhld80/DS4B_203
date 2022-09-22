# BUSINESS SCIENCE UNIVERSITY
# DS4B 203-R: TIME SERIES FORECASTING FOR BUSINESS
# MODULE: MODELTIME WORKFLOW FOR FORECASTING

# GOAL ----
# Deep-dive into modeltime

# OBJECTIVES ----
# - Understand the Modeltime Workflow 
# - Understand Accuracy Measurements 
# - Understand the Forecast Horizon & Confidence Intervals
# - Why refit? 

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

recipe_spec_2_lag    <- feature_engineering_artifacts_list$recipes$recipe_spec_2

# TRAIN / TEST ----

splits <- data_prepared_tbl %>%
    time_series_split(assess = "8 weeks", 
                      # initial = "1 year 1 months"
                      cumulative = TRUE)

splits %>%
    tk_time_series_cv_plan() %>%
    plot_time_series_cv_plan(optin_time, optins_trans)



# 1.0 MAKING MODELS ----
# - Works with Parnsip & Workflows
# - Models must be fit (trained)

# * Parsnip Model (ARIMA)  ----


# * Workflow (ARIMA + Date Features) ----


# * Workflow (GLMNET + XREGS) ----




# 2.0 MODELTIME TABLE ----
# - Organize



# 3.0 CALIBRATION ----
# - Calculates residual model errors on test set
# - Gives us a true prediction error estimate when we model with confidence intervals



# 4.0 TEST ACCURACY ----
# - Calculates common accuracy measures
# - MAE, MAPE, MASE, SMAPE, RMSE, R-SQUARED



# 5.0 TEST FORECAST ----
# - Visualize the out-of-sample forecast


# 6.0 REFITTING

# * Refit ----


# * Final Forecast ----
# - 'new_data' vs 'h'
# - 'actual_data'
# - Preprocessing



