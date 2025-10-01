install.packages(c('readxl', 'dplyr', 'plm', 'lubridate', 'fixest', 'corrplot', 'performance', 'clubSandwich', 'car','marginaleffects','fwildclusterboot','lme4','pscl','pROC','DescTools','glmmTMB'))
lapply(c("readxl", "dplyr", "plm", "lubridate", "fixest", "corrplot", "performance", "clubSandwich", "car","marginaleffects","fwildclusterboot","lme4","pscl","pROC","DescTools","glmmTMB"), library, character.only = TRUE)

#Importing Dataset
data <- Match_Panel %>%
  mutate(
    Date = as.Date(Date, format = "%Y-%m-%d"),
    Year = factor(format(Date, "%Y")),
    Team = factor(Team)
  )

pdata_match <- pdata.frame(data,
                           index = c("Team", "Date"),
                           drop.index = FALSE
)

#Measuring Dataset's Dimensions
pdim(pdata_match)


#Specification 1

#Two-way Fully-saturated Fixed-Effects Logit Model (Team x Year)
data$Team <- as.factor(data$Team)
data$Year <- as.factor(data$Year)
data$TeamYear <- interaction(data$Team, data$Year, drop = TRUE, sep=":")

logit_mod_sat <- glm(
  Dismissal ~ Derby_Loss_AC + Derby_Loss_SC + Elimination + Under_Exp +
    factor(TeamYear),
  data = data,
  family = binomial("logit")
)

#Summary
summary(logit_mod_sat)

#Variance Inflation Factors
check_collinearity(logit_mod_sat)

#Cluster Robust Inference by Team/Club
vcov_cr2 <- vcovCR(logit_mod_sat,
                   cluster = pdata_match$Team,
                   type = "CR2"
)
coef_test(logit_mod_sat, vcov = vcov_cr2,)
length(unique(interaction(pdata_match$Team)))

#Goodness of Fit Metrics & Predictive Accuracy
model_performance(logit_mod_sat)
DescTools::PseudoR2(logit_mod_sat, which = c("McFadden","McFaddenAdj","CoxSnell","Nagelkerke","Tjur","Efron"))
brier <- mean((data$Dismissal - fitted(logit_mod_sat))^2)
auc <- pROC::auc(pROC::roc(data$Dismissal, fitted(logit_mod_sat)))
brier; auc

#Wald Test - Hotelling’s T² (AHT)
Vc <- vcovCR(logit_mod_sat, cluster = data$Team, type = "CR2")
Wald_test(logit_mod_sat,
          constraints = constrain_zero(c("Derby_Loss_AC","Derby_Loss_SC",
                                         "Elimination","Under_Exp")),
          vcov = Vc, test = "HTZ")

#Average Partial Effects (APE)
avg_comparisons(logit_mod_sat,
                variables = c("Derby_Loss_AC", "Derby_Loss_SC", "Elimination","Under_Exp"),
                vcov = vcov_cr2
)


#Specification 2

#Two-way Additive Fixed-Effects Logit Model (Team + Year)
logit_mod_add <- glm(
  Dismissal ~ Derby_Loss_AC + Derby_Loss_SC + Elimination + Under_Exp +
    factor(Team) + factor(Year),
  data = data,
  family = binomial("logit")
)

#Summary
summary(logit_mod_add)

#Variance Inflation Factors
check_collinearity(logit_mod_add)

#Cluster Robust Inference by Team
vcov_cr2 <- vcovCR(logit_mod_add,
                   cluster = pdata_match$Team,
                   type = "CR2"
)
coef_test(logit_mod_add, vcov = vcov_cr2,)
length(unique(interaction(pdata_match$Team)))

#Goodness of Fit Metrics & Predictive Accuracy
model_performance(logit_mod_add)
DescTools::PseudoR2(logit_mod_add, which = c("McFadden","McFaddenAdj","CoxSnell","Nagelkerke","Tjur","Efron"))
brier <- mean((data$Dismissal - fitted(logit_mod_add))^2)
auc <- pROC::auc(pROC::roc(data$Dismissal, fitted(logit_mod_add)))
brier; auc

#Wald Test - Hotelling’s T² (AHT)
Vc <- vcovCR(logit_mod_add, cluster = data$Team, type = "CR2")
Wald_test(logit_mod_add,
          constraints = constrain_zero(c("Derby_Loss_AC","Derby_Loss_SC",
                                         "Elimination","Under_Exp")),
          vcov = Vc, test = "HTZ")

#Average Partial Effects (APE)
avg_comparisons(logit_mod_add,
                variables = c("Derby_Loss_AC", "Derby_Loss_SC", "Elimination","Under_Exp"),
                vcov = vcov_cr2
)