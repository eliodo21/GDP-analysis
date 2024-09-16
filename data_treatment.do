import excel "C:\Users\thanh\OneDrive - University of Leeds\Desktop\data.xlsx", sheet("Sheet1") firstrow
//set timeseries data and graph GDP
tsset datevar
tsline GDP
su GDP
///check for autocorrelation///trend for non-stationary
corrgram GDP, lags (20)
help corrgram
ac GDP
regress D1.GDP  L1.GDP , nocon
predict residGDP , res
corrgram residGDP, lags(20)
ac residGDP, lags(20)
dfuller GDP ,  nocon
pperron GDP , nocon
tsline GDP
///treat non-stationary issues
gen FD_GDP=D.GDP
label var FD_GDP "First difference of VN GDP"
tsline FD_GDP
gen SD_GDP=D2.GDP
label var SD_GDP "Second difference of VN GDP"
tsline SD_GDP
corrgram SD_GDP, lags(20)
ac SD_GDP, lags(20)
ac GDP, lags(20)
ac SD_GDP, lags(20)
///generate GDP growth rate
gen rGDPgr= ((GDP-L1.GDP)-1)*100
label var rGDPgr "real VN GDP growth rate"
br
drop rGDPgr
gen rGDPgr= ((GDP/L1.GDP)-1)*100
label var rGDPgr "real VN GDP growth rate"
ac rGDPgr, lags(20)
tsline rGDPgr
ac rGDPgr, lags(20)
///unit-root tests
arima rGDPgr, ar(1)
arima rGDPgr, arima(1,0,0)
estat aroots
arima rGDPgr, arima(2,0,0)
estat aroots
arima rGDPgr, ar(2)
quietly arima rGDPgr, ar(2)
predict yhat_AR2
///forecasting
tsappend, add(10)
predict frGDPgr, y dynamic(y(2033))
label variable frGDPgr "forecasted GDP"
tsline rGDPgr frGDPgr