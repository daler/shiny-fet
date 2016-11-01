# Shiny FET

Shiny app for getting some intuition on a Fisher's exact test. Intended for
demonstrating the effects of changing marginal totals and individual cells of
a 2x2 FET table.

See a working example at https://daler.shinyapps.io/lcdb_fet, or clone and
upload your own to shinyapps.io.

### Explanation

#### Input controls
Input controls can be used to build a table. Tables, pval, odds ratio, and
figures are updated automatically.

#### Tables
Tables are shown both as total counts as well as in versions that show row
percentages and column percentages to help with interpretation.

#### Mosaic plot
The mosaic plot shows the relative size of cells in table. When a table is not
different from the null hypothesis, the gaps in the mosaic plot will form
a cross-shape. The more divergent from a cross-shape, the higher the odds
ratio.

#### Line plot
The black line shows the expected distribution of the top-left cell of the
table ("upregulated AND peak"), given the marginal values of the table (total
genes assayed, total genes with a peak, total upregulated genes). Try modifying
those values and watch the position of the null distribution shift.

The blue vertical line shows the current value of "upregulated AND peak". When
the blue line is close to the middle of the black distribution, it is close to
the expected value and therefore we get a non-significant p-value and odds
ratios close to 1.
