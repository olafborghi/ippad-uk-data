# Make a transparent version of the IP-PAD logo. The original has a white
# background, which shows as a box on the site's off-white background. Near
# white pixels become transparent, with a soft edge so outlines stay smooth.
# Run once from the site root with `Rscript scripts/make_logo.R`.

library("here")
library("png")

logo <- readPNG(here("assets", "logo_original.png"))

# whiteness: 1 for pure white, 0 for any clearly coloured or dark pixel
whiteness <- pmin(logo[, , 1], logo[, , 2], logo[, , 3])
alpha <- pmin(1, pmax(0, (1 - whiteness) / 0.12))

logo[, , 4] <- alpha
writePNG(logo, here("assets", "logo.png"))
