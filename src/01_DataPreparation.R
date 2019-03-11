require(readxl)
require(data.table)

Sys.setlocale("LC_ALL", 'en_US.UTF-8') # for Umlaute (does not work on Windows systems)

data_sat = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 1)
data_sun = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 2)
data_mon = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 3)
data_tue = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 4)
data_wed = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 5)
data_thu = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 6)
data_fri = read_excel("data/BeerAnalysis_Anonymized.xlsx", sheet = 7)

# convert bottles to liters
convertToLiters = function(obj) {
  obj$Bier = obj$Bier*.5
  obj$Wein = obj$Wein*1
  obj$Citron_Fanta = obj$Citron_Fanta*1.5
  obj$Cola = obj$Cola*1.5
  obj$Apfelschorle = obj$Apfelschorle*1.5
  obj$Wasser = obj$Wasser*1.5
  return(obj)
}

data_sat = convertToLiters(data_sat)
data_sun = convertToLiters(data_sun)
data_mon = convertToLiters(data_mon)
data_tue = convertToLiters(data_tue)
data_wed = convertToLiters(data_wed)
data_thu = convertToLiters(data_thu)
data_fri = convertToLiters(data_fri)

# set timestamp
data_sat$Day = as.POSIXct("2019-03-02")
data_sun$Day = as.POSIXct("2019-03-03")
data_mon$Day = as.POSIXct("2019-03-04")
data_tue$Day = as.POSIXct("2019-03-05")
data_wed$Day = as.POSIXct("2019-03-06")
data_thu$Day = as.POSIXct("2019-03-07")
data_fri$Day = as.POSIXct("2019-03-08")

# concatenate data (cumulated sums)
cum_data = rbind(data_sat, 
                 data_sun, 
                 data_mon, 
                 data_tue, 
                 data_wed, 
                 data_thu, 
                 data_fri)
cum_data = as.data.table(cum_data) # convert to data.table for better data wrangling

# build differences
diff_data_sat = data_sat
diff_data_sun = data_sun
diff_data_mon = data_mon
diff_data_tue = data_tue
diff_data_wed = data_wed
diff_data_thu = data_thu
diff_data_fri = data_fri

diff_data_sun[, 2:7] = diff_data_sun[, 2:7] - data_sat[, 2:7]
diff_data_mon[, 2:7] = diff_data_mon[, 2:7] - data_sun[, 2:7]
diff_data_tue[, 2:7] = diff_data_tue[, 2:7] - data_mon[, 2:7]
diff_data_wed[, 2:7] = diff_data_wed[, 2:7] - data_tue[, 2:7]
diff_data_thu[, 2:7] = diff_data_thu[, 2:7] - data_wed[, 2:7]
diff_data_fri[, 2:7] = diff_data_fri[, 2:7] - data_thu[, 2:7]

diff_data = rbind(diff_data_sat, 
                  diff_data_sun, 
                  diff_data_mon,
                  diff_data_tue, 
                  diff_data_wed,
                  diff_data_thu,
                  diff_data_fri)

diff_data = as.data.table(diff_data)

# clean up workspace
rm(data_sat)
rm(data_sun)
rm(data_mon)
rm(data_tue)
rm(data_wed)
rm(data_thu)
rm(data_fri)
rm(diff_data_sat)
rm(diff_data_sun)
rm(diff_data_mon)
rm(diff_data_tue)
rm(diff_data_wed)
rm(diff_data_thu)
rm(diff_data_fri)