install.packages(c('survival', 'survminer', 'dplyr', 'tidyr', 'lubridate', 'broom', 'gtsummary', 'patchwork', 'scales', 'purrr', 'patchwork'))
lapply(c("survival", "survminer", "dplyr", "tidyr", "lubridate", "broom", "gtsummary", "patchwork", "scales", "purrr", "patchwork"), library, character.only = TRUE)

#Importing Dataset
df <- Kaplan_Meier_Matches |>
  mutate(
    event     = as.integer(event),
    time_matches = as.integer(time_matches)
  )

#Verifying the number of censored managerial spells
N_total    <- nrow(df)
N_events   <- sum(df$event == 1, na.rm = TRUE)
N_censored <- sum(df$event == 0, na.rm = TRUE)
N_total; N_events; N_censored


#Kaplan-Meier Survival Curve (Matches)
km <- survfit(Surv(time_matches, event) ~ 1, data = df)

#Median Tenure Duration (Matches)
fit <- survfit(Surv(time_matches, event) ~ 1, data = df, conf.type = "log-log")
km_median_lcl <- summary(fit)$table["0.95LCL"]
km_median_ucl <- summary(fit)$table["0.95UCL"]
surv_median(fit)

#Different Time Horizons (Matches)
summary(fit, times = c(1,5, 15, 30, 50, 75, 100, 200, 300))

#Plot
p_matches <- ggsurvplot(
  km, data = df,
  conf.int        = TRUE,
  conf.int.alpha  = 0.15,
  censor          = TRUE,
  censor.shape    = 3,
  censor.size     = 1.8,
  palette         = "#C74E4E",
  surv.median.line= "hv",
  break.time.by   =20,
  xlim            = c(0, quantile(df$time_matches, 0.98, na.rm = TRUE)),
  xlab            = "Tenure Duration (matches)",
  ylab            = "Survival Probability (%)",
  title           = "Kaplan–Meier Survival Curve",
  ggtheme         = theme_minimal(base_size = 9),
  legend          = "none"
)

med <- summary(km)$table["median"]
N   <- nrow(df)

p_matches$plot <- p_matches$plot +
  theme(
    plot.title   = element_text(face = "bold", hjust = 0.5),
    axis.title   = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  ) +
  labs(caption = paste0("N = ", N, 
                        " spells   |   Median survival ≈ ",
                        round(med, 0), " matches"))

p_matches