# intrastate-rivalries

install.packages("renv")
renv::init()

install.packages(c('readxl', 'dplyr', 'plm', 'lubridate', 'fixest', 'corrplot', 'performance', 'clubSandwich', 'car', 'marginaleffects', 'fwildclusterboot', 'lme4', 'pscl', 'pROC', 'DescTools', 'glmmTMB', 'survival', 'survminer', 'dplyr', 'tidyr', 'lubridate', 'broom', 'gtsummary', 'patchwork', 'scales', 'purrr', 'patchwork'))
lapply(c("readxl", "dplyr", "plm", "lubridate", "fixest", "corrplot", "performance", "clubSandwich", "car", "marginaleffects", "fwildclusterboot", "lme4", "pscl", "pROC", "DescTools", "glmmTMB", "survival", "survminer", "dplyr", "tidyr", "lubridate", "broom", "gtsummary", "patchwork", "scales", "purrr", "patchwork"), library, character.only = TRUE)

renv::snapshot()
#renv::restore()

