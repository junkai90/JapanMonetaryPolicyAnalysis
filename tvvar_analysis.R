# Time-Varying VAR analysis of Japan monetary policy impact on currency rate
#
# This script downloads macroeconomic data from FRED and fits a
# time-varying vector autoregression (TV-VAR) using the tvReg package.
# It then plots the impulse response functions and the forecast error
# variance decomposition.

# Load required packages
library(quantmod)   # for downloading data
library(tvReg)      # for time-varying VAR estimation

# Symbols: currency rate (JPY/USD), GDP, industrial production,
# and short-term interest rate as a proxy for monetary policy
symbols <- c("DEXJPUS", "JPNRGDP", "JPNIPBIS", "IR3TIB01JPM156N")
getSymbols(symbols, src = "FRED")

# Merge and convert to quarterly frequency using averages
macro_monthly <- merge(DEXJPUS, JPNRGDP, JPNIPBIS, IR3TIB01JPM156N)
macro_quarterly <- na.omit(apply.quarterly(macro_monthly, mean))
colnames(macro_quarterly) <- c("currency", "gdp", "ipi", "rate")

# Transform variables to logarithms where appropriate
macro_quarterly$currency <- log(macro_quarterly$currency)
macro_quarterly$gdp <- log(macro_quarterly$gdp)
macro_quarterly$ipi <- log(macro_quarterly$ipi)

# Estimate a time-varying VAR with two lags
# Bandwidth is selected automatically by tvReg
japan_tvvar <- tvVAR(macro_quarterly, p = 2, type = "const")

# Impulse response of a monetary policy shock (rate) on currency
irf_res <- tvirf(japan_tvvar, impulse = "rate", response = "currency",
                 n.ahead = 12, ortho = TRUE, cumulative = FALSE,
                 boot = TRUE, runs = 100)
plot(irf_res, main = "Impulse response of policy rate shock on currency")

# Forecast error variance decomposition
fevd_res <- tvfevd(japan_tvvar, n.ahead = 12)
plot(fevd_res, main = "Forecast error variance decomposition")
