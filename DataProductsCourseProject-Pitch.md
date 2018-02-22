Coursera Data Products Course Project - Pitch
========================================================
author: John B Cheadle
date: 21 FEB 2018
autosize: true
transition: rotate



<style>
.small-code pre code {
  font-size: 1em;
}
</style>


Introducing the Stock Trend Viewer
========================================================

The Stock Trend Viewer utilizes the **quantmod** and **plotly** packages to give an up-to-date (last 100 days maximum) trend of the close stock price of user's choosing.

How it works (code)
========================================================
class: small-code


```r
df <- data.frame(Date=index(AMZN),coredata(AMZN))
df <- tail(df, 60)
df$ID <- seq.int(nrow(df))

accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

df <- df %>%
  accumulate_by(~ID)

head(df)
```


How it works (explanation)
========================================================
class: small-code

```
        Date AMZN.Open AMZN.High AMZN.Low AMZN.Close AMZN.Volume
1 2017-11-22   1141.00   1160.27  1141.00    1156.16     3555300
2 2017-11-22   1141.00   1160.27  1141.00    1156.16     3555300
3 2017-11-24   1160.70   1186.84  1160.70    1186.00     3528000
4 2017-11-22   1141.00   1160.27  1141.00    1156.16     3555300
5 2017-11-24   1160.70   1186.84  1160.70    1186.00     3528000
6 2017-11-27   1202.66   1213.41  1191.15    1195.83     6744000
  AMZN.Adjusted ID frame
1       1156.16  1     1
2       1156.16  1     2
3       1186.00  2     2
4       1156.16  1     3
5       1186.00  2     3
6       1195.83  3     3
```
Enter in whatever stock ticker symbol you'd like!  Here, we use AMZN as an example.  Behind the scences, the last x days of stock prices are combined into a dataframe.  The **plotly** package is used to nicely plot the close price over time.  One can even animate the trend by pressing the 'Play' button.

Unfortunately plot_ly does not work with Rpres, so no example plot can be included here.  However, feel free to try the shiny application yourself!

Features of the Stock Trend Viewer
========================================================

- User-entered stock ticker symbol
- Choose amount of time to look back in stock price history (MAX: 100 days) 
- Customizable trend-line color and fill color
- Automate trend line or drag slider to desired day
- Hover over trend line to display day and closing price
- Click and drag to zoom in on different parts of trend line
