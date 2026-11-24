# Shared setup for every page of the site that uses R. Start a page with
#
#   source(here::here("R", "site.R"))
#
# It loads the packages, the brand colours, the site data and the figure
# theme. It creates these objects:
#
#   brand            named vector of all colours in _brand.yml
#   dataset_colours  colour of each survey (hue = provider, lightness = wave)
#   gender_colours   colours for gender comparisons
#   respondents      one row per interview, factors in their level order
#   panel            one row per person interviewed in both waves
#   variables        label, question, type and note of every variable
#   site_caption     default figure caption
#
# The site data are built by scripts/build_site_data.qmd.

library("groundhog")
groundhog.library(c("here", "tidyverse", "yaml", "scales"), "2026-07-01")

# falo is the figure theme, installed from GitHub with
# pak::pak("olafborghi/FinallyAmazingLookingOutput")
library("falo")

# Brand colours ----------------------------------------------------------

brand <- read_yaml(here("_brand.yml"))$color$palette |>
  unlist()

dataset_colours <- c(
  "Gallup W1" = brand[["gallup-w1"]],
  "Survation W1" = brand[["survation-w1"]],
  "Gallup W2" = brand[["gallup-w2"]],
  "Survation W2" = brand[["survation-w2"]]
)

# the darker tone of each provider, for comparisons of Gallup and Survation
provider_colours <- c(
  "Gallup International" = brand[["blue-dark"]],
  "Survation" = brand[["coral-dark"]]
)

# blue and coral stay apart under every kind of colour blindness
gender_colours <- c(
  "Female" = brand[["coral-dark"]],
  "Male" = brand[["blue-dark"]],
  "Other" = brand[["muted"]]
)

# Site data --------------------------------------------------------------

site_levels <- read_csv(here("data", "levels.csv"), show_col_types = FALSE) |>
  arrange(variable, order)

variables <- read_csv(here("data", "variables.csv"), show_col_types = FALSE)

# Only empty fields are missing, so answers typed as "NA" stay text
respondents <- read_csv(
  here("data", "respondents.csv"),
  na = "",
  show_col_types = FALSE,
  guess_max = 5000
)

# Factors get the level order of the combined data
level_list <- split(site_levels$level, site_levels$variable)
ordered_vars <- unique(site_levels$variable[site_levels$ordered])

respondents <- respondents |>
  mutate(
    across(
      all_of(names(level_list)),
      \(x) factor(x, levels = level_list[[cur_column()]], ordered = cur_column() %in% ordered_vars)
    )
  )

panel <- read_csv(here("data", "panel.csv"), na = "", show_col_types = FALSE)

# Figures ----------------------------------------------------------------

site_caption <- "Source: IP-PAD UK combined data (version 1.0). Unweighted."

theme_set(
  theme_allround(base_size = 13) +
    theme(
      plot.background = element_rect(fill = brand[["paper"]], colour = NA),
      panel.background = element_rect(fill = brand[["paper"]], colour = NA),
      legend.background = element_rect(fill = brand[["paper"]], colour = NA),
      plot.title.position = "plot",
      plot.caption.position = "plot",
      plot.caption = element_text(colour = brand[["muted"]], hjust = 0),
      # panel headings as plain bold text, aligned left, without a box
      strip.background = element_blank(),
      strip.text = element_text(face = "bold", hjust = 0),
      # legends at the top line up with the title
      legend.location = "plot"
    )
)

# text drawn inside a chart (geom_text, geom_label) in the site font
update_geom_defaults("text", aes(family = "Public Sans Regular"))
update_geom_defaults("label", aes(family = "Public Sans Regular"))
