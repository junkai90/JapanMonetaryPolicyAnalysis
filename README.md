# JapanMonetaryPolicyAnalysis

VAR and its variants are used to analyse the impact of Japan monetary policy.

## Time-Varying VAR example

`tvvar_analysis.R` downloads macroeconomic data from FRED and estimates a
Time-Varying Vector Autoregression (TV-VAR) with currency rate, GDP,
industrial production, and a short-term interest rate.

It then plots the impulse response function of a monetary policy shock
and the forecast error variance decomposition.

Run the script with:

```r
Rscript tvvar_analysis.R
```
