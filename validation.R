
library(readr)
library(glmtoolbox)
library(dplyr)
library(ggplot2)

results_data <- read_csv("data/results_for_r.csv")

actuals <- as.numeric(results_data$actual_default)
probabilities <- as.numeric(results_data$probability_default)

hl_test_result <- hltest(actuals, probabilities)
print(hl_test_result)

capture.output(hl_test_result, file="hosmer_lemeshow_output.txt")
print("Hasil Hosmer-Lemeshow telah disimpan.")

print("--- Membuat Kurva Kalibrasi ---")
calibration_data <- results_data %>%
  mutate(prob_bin = cut(probability_default, breaks = 10)) %>%
  group_by(prob_bin) %>%
  summarise(
    mean_predicted_prob = mean(probability_default),
    actual_proportion = mean(actual_default),
    n = n()
  ) %>%
  filter(n > 0)

calibration_plot <- ggplot(calibration_data, aes(x = mean_predicted_prob, y = actual_proportion)) +
  geom_point(color = "darkblue", size = 3, alpha = 0.7) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  labs(
    title = "Calibration Curve for Credit Risk Model",
    x = "Mean Predicted Probability of Default",
    y = "Actual Proportion of Default"
  ) +
  theme_minimal()

ggsave("calibration_curve.png", plot = calibration_plot, width = 8, height = 6)
print("Plot 'calibration_curve.png' telah berhasil disimpan.")

print("--- Menganalisis Cut-off Score untuk Default Rate <= 5% ---")
cutoff_analysis <- results_data %>%
  arrange(desc(credit_score)) %>%
  mutate(
    cumulative_defaults = cumsum(actual_default),
    cumulative_population = row_number(),
    cumulative_default_rate = cumulative_defaults / cumulative_population
  )

print("Contoh hasil analisis cut-off (lihat 20 baris pertama):")
print(head(cutoff_analysis, 20))
