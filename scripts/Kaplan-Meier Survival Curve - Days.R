install.packages(c('survival','survminer','dplyr','tidyr','lubridate','broom','gtsummary','patchwork','scales','purrr','patchwork'))
lapply(c("survival","survminer","dplyr","tidyr","lubridate","broom","gtsummary","patchwork","scales","purrr","patchwork"), library, character.only = TRUE)

#Importing Dataset
df <- Kaplan_Meier_Days |>
  mutate(
    event     = as.integer(event),
    time_days = as.integer(time_days)
  )

#Verifying the number of censored manageria spells
N_total    <- nrow(df)
N_events   <- sum(df$event == 1, na.rm = TRUE)
N_censored <- sum(df$event == 0, na.rm = TRUE)
N_total; N_events; N_censored


#Kaplan-Meier Survival Curve (Days)
km <- survfit(Surv(time_days, event) ~ 1, data = df)

#Median Tenure Duration (Days)
fit <- survfit(Surv(time_days, event) ~ 1, data = df, conf.type = "log-log")
km_median_lcl <- summary(fit)$table["0.95LCL"]
km_median_ucl <- summary(fit)$table["0.95UCL"]
surv_median(fit)

#Different Time Horizons (Days)
summary(fit, times = c(1, 30, 60, 90, 120, 180, 240, 365, 730, 1095))

#Plot
p_days <- ggsurvplot(
  km, data = df,
  conf.int        = TRUE,
  conf.int.alpha  = 0.15,
  censor          = TRUE,
  censor.shape    = 3,
  censor.size     = 1.8,
  palette         = "#C74E4E",
  surv.median.line= "hv",
  break.time.by   =90,
  xlim            = c(0, quantile(df$time_days, 0.98, na.rm = TRUE)),
  xlab            = "Tenure Duration (days)",
  ylab            = "Survival Probability (%)",
  title           = "Kaplan–Meier Survival Curve",
  ggtheme         = theme_minimal(base_size = 9),
  legend          = "none"
)

med <- summary(km)$table["median"]
N   <- nrow(df)

p_days$plot <- p_days$plot +
  theme(
    plot.title   = element_text(face = "bold", hjust = 0.5),
    axis.title   = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  ) +
  labs(caption = paste0("N = ", N, 
                        " spells   |   Median survival ≈ ",
                        round(med, 0), " days"))

p_days