How to reproduce the analysis:

1. Clone or download this repository:
git clone https://github.com/ppiquetpessoa/intrastate-rivalries.git

2. Open the project in RStudio:
Or set your working directory to the folder you just cloned

3. Install the required R packages:

- Kaplan-Meier Survival Analysis:
  install.packages(c('survival', 'survminer', 'dplyr', 'tidyr', 'lubridate', 'broom', 'gtsummary', 'patchwork', 'scales', 'purrr', 'patchwork'))

- Fixed-Effects Logit Models:
  install.packages(c('readxl', 'dplyr', 'plm', 'lubridate', 'fixest', 'corrplot', 'performance', 'clubSandwich', 'car','marginaleffects','fwildclusterboot','lme4','pscl','pROC','DescTools','glmmTMB'))

4. Run the scripts (either step by step or all at once):
source("")
source("scripts/02_models_logit.R")
source("Fixed-Effects Logit Models.R")

If you use this material, please cite:
P. Piquet (2025). Intrastate Rivalries and Managerial Turnover in Brazilian Football.
GitHub repository: https://github.com/ppiquetpessoa/intrastate-rivalries
