# IP-PAD UK Data

This repository holds the website of the IP-PAD UK data, which is online at <https://olafborghi.com/ippad-uk-data>. Between 2024 and 2026, the IP-PAD Doctoral Network surveyed young people aged 12 to 26 in the United Kingdom about politics, in four online surveys run by Gallup International and Survation. The website describes these surveys, presents short articles on selected findings, and includes an explorer in which visitors can compare answers between groups of young people themselves.

The site is built with [Quarto](https://quarto.org). R prepares the data and draws the figures of the articles, while the explorer runs in the visitor's browser with Observable JS. The site is therefore fully static and is hosted on GitHub Pages.

## Building the site

You need Quarto 1.10 or later and R 4.6. The R packages are loaded with `groundhog`, which installs them as they were on CRAN on 1 July 2026. The figure theme comes from the `falo` package, which you can install with `pak::pak("olafborghi/FinallyAmazingLookingOutput")`.

```sh
quarto preview                              # preview the site in the browser
quarto render                               # build the site into _site/
quarto render scripts/build_site_data.qmd   # rebuild data/ from the combined data
```

The pages are frozen (`freeze: auto`), so they only run their R code again when their source changes, and the results are kept in `_freeze/`. Rebuilding the site data is only needed when the combined data change, and it requires the combined data file in a folder `ippad_combined` next to this repository.

## Publishing

The site is published to the `gh-pages` branch of this repository with

```sh
quarto publish gh-pages
```

GitHub Pages serves that branch. Because the site is a project site of the account `olafborghi`, it appears under the custom domain of the account's user site.

## How the site is organised

- `_brand.yml` holds all colours, fonts and the logo. The site theme, the R figures and the explorer all read from it, so colours only need to be changed there. After a change, `Rscript R/palette_check.R` checks that the colours of the four surveys remain distinguishable for readers with colour blindness.
- `R/site.R` is loaded at the start of every page with R code. It reads the site data and sets the figure theme and colours.
- `config/explorer_variables.csv` lists the questions that the explorer offers, with a short label, a topic and, where needed, a note written for visitors. `config/compare_by.csv` lists the characteristics that answers can be compared by.
- `scripts/build_site_data.qmd` builds the files in `data/` from the combined data. Open answers and identifiers are left out, and interview dates are kept as months only.
- Each article is a folder in `insights/uk/`, with its page and a thumbnail for the listing.

## Extending the site

To add an article, copy `insights/_template.qmd` to a new folder `insights/uk/<short-name>/index.qmd` and fill it in. It appears on the Insights page and on the home page by itself. To add a question to the explorer, add a row to `config/explorer_variables.csv` and rebuild the site data. All site data carry a `country` column, so that data from the other IP-PAD countries can be appended later, together with a new folder such as `insights/cross-country/`.

Articles we would like to add include the labels young people use to describe their politics (feminist, environmentalist and others), their willingness to take part in politics, how certain they are about their political views, and psychological measures such as worries about the future and dogmatism.

## Licence

The data, text and figures are released under CC BY 4.0, and the code under the MIT licence. See `LICENSE.md` for details and for how to cite the data.
