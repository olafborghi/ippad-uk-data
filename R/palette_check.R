# Check the colours of _brand.yml for colour blindness and contrast.
# Run from the site root after any change to the colours:
#
#   Rscript R/palette_check.R
#
# The four dataset colours must stay apart (colour difference of at least 20)
# under normal vision and under simulated deuteranopia, protanopia and
# tritanopia. Text colours need a contrast of at least 4.5 against the page.

library("here")
library("yaml")
library("colorspace")

palette <- unlist(read_yaml(here("_brand.yml"))$color$palette)
page <- palette[["paper"]]

datasets <- palette[c("gallup-w1", "survation-w1", "gallup-w2", "survation-w2")]

# smallest colour difference (CIE Lab distance) between any two colours
min_difference <- \(colours) {
  distances <- dist(coords(as(hex2RGB(colours), "LAB")))
  min(distances)
}

simulations <- list(
  normal = datasets,
  deuteranopia = deutan(datasets),
  protanopia = protan(datasets),
  tritanopia = tritan(datasets)
)

differences <- vapply(simulations, min_difference, numeric(1))

cat("Smallest colour difference between dataset colours\n")
print(round(differences, 1))

# WCAG contrast ratio, from the relative luminance of sRGB colours
luminance <- \(colours) {
  rgb <- coords(hex2RGB(colours))
  linear <- ifelse(rgb <= 0.03928, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
  drop(linear %*% c(0.2126, 0.7152, 0.0722))
}

contrast <- (pmax(luminance(palette), luminance(page)) + 0.05) /
  (pmin(luminance(palette), luminance(page)) + 0.05)

cat("\nContrast against the page background\n")
print(round(contrast, 2))

stopifnot(
  "dataset colours too close for colour blind readers" = all(differences >= 20),
  "text colours need a contrast of 4.5" = all(contrast[c("ink", "muted", "blue-dark")] >= 4.5)
)

cat("\nAll checks passed.\n")
