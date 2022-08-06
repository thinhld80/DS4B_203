# BUSINESS SCIENCE UNIVERSITY
# DS4B 203-R: ADVANCED TIME SERIES FORECASTING FOR BUSINESS
# MODULE: TIME SERIES JUMPSTART 

# GOAL: Forecast Daily Email Users - Next 8-WEEKS

# OBJECTIVES ----
# - Dive into a time-series analysis project
# - Experience Frameworks: modeltime
# - Experience 2 Algorithms:
#   1. Prophet
#   2. LM w/ Engineered Features

# LIBRARIES ----

# Time Series Machine Learning Models
library(tidymodels)
library(modeltime)

# EDA
library(DataExplorer)


#Core
library(tidyverse)
library(timetk)
library(lubridate)

# DATA -----

mailchimp_users_tbl <- read_rds("00_data/mailchimp_users.rds")

mailchimp_users_tbl

# 1.0 EDA & DATA PREP ----
# * DAILY SUBSCRIBERS INCREASES

mailchimp_users_tbl %>% glimpse()

mailchimp_users_tbl

# * Count of Optins by Day ----

optins_day_tbl <- mailchimp_users_tbl %>%
  summarise_by_time(
    .date_var = optin_time,
    .by       = "day",
    optins    = n()
  )

optins_day_tbl

#  * Summary Diagnostics ----

optins_day_tbl %>% tk_summary_diagnostics(.date_var = optin_time)

# 2.0 EVALUATION PERIOD ----





# 3.0 PROPHET FORECASTING ----




# 4.0 FORECASTING WITH FEATURE ENGINEERING ----





# 5.0 SUMMARY & NEXT STEPS ----

# * What you've learned ----
# - You've been exposed to:
#   - Tidymodels / Modeltime Framework
# - You've seen 2 modeling approaches:
#   - Prophet - Univariate, Automatic
#   - Linear Regression Model - Many recipe steps
# - You've experienced Feature Engineering
#   - Visualizations: ACF, Seasonality
#   - Feature Engineering from Date Variables
#
# * Where you are going! ----
# - You still need to learn:
#   - New algorithms
#   - Machine Learning - How to tune parameters
#   - Feature Engineering Strategies
#   - Ensembling - Competition winning strategy
#   - and a lot more!

