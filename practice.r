
setwd('D:/Docs/GitHub/Market-Matrix/')

library(magrittr)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(quantmod)


# read inflation data
us_inflation <- read_csv("files/us_inflation.csv", col_types = cols(YEAR = col_number()))

us_inflation %>%
  gather(key = 'month', value = 'monthly_inflation_rate', JAN:DEC) -> us_inflation_tidy


# read in source data to calculate returns in range 1950-2019
dataFile <- "^GSPC.csv"
dataFile_strip <- "^GSPC_update.csv"
dataDir <- "files"
file <- paste(dataDir,"/",dataFile,sep="")
file2 <- paste(dataDir,"/",dataFile_strip,sep="")

csv <- read.csv(file,header=TRUE,sep=",")
csv$Date <- as.POSIXct(as.character(csv$Date),tz="",format="%Y-%m-%d")

csv %<>% na.omit()
row.names(csv) <- csv$Date
csv %<>% select(-Date, -Close)

#write the file and remove the column with symbol name
write.csv(csv,file2,row.names=TRUE)

#import for quantmod
dataFile_strip <- "^GSPC_update.csv"
dataDir <- "files"
file2 <- paste(dataDir,"/",dataFile_strip,sep="")

zz <- read.zoo(file2, sep = ",", header=TRUE,index.column=1)
SPY<- as.xts(zz)

#cleanup
rm(csv,dataDir,dataFile,dataFile_strip,file,file2,zz)


# real return after inflation (1 + return)/(1 + inflation) - 1

allReturns(SPY)  # returns all periods

yearly_return <- fortify.zoo(periodReturn(SPY,period='yearly')) # returns yearly
yearly_return %<>% rename( year_end_date = Index, yearly_return = yearly.returns )
yearly_return %<>% mutate( year = as.integer(format(year_end_date, "%Y")) )
yearly_return %<>% select(-year_end_date)

# returns yearly

yearly_inflation <- us_inflation_tidy %>% group_by(YEAR) %>% summarize(annual_inflation = mean(monthly_inflation_rate) ) %>% select(YEAR,annual_inflation)

yearly_return_w_inflation <- data.frame(Year = seq(from = min(yearly_return$year), to = max(yearly_return$year) ) )

yearly_return_w_inflation %<>% 
  left_join(yearly_return, by = c("Year" = "year")) %>%
    left_join(yearly_inflation, by = c("Year" = "YEAR")) %>%
      mutate(real_return =  (1 + yearly_return)/(1 + annual_inflation/100) - 1  )

  # build x,y maps

yearly_return$year %>% unique() -> df_years
df_years[-length(df_years)] -> df_years_x
df_years[-1] -> df_years_y

#given x,y, calculate return after inflation 1 off

portfolio_input <- 10000
as.numeric(df_years_x[1])
as.numeric(df_years_y[1])

yearly_return_w_inflation$real_return[ yearly_return_w_inflation$Year >= as.numeric(df_years_x[1]) & yearly_return_w_inflation$Year <= as.numeric(df_years_x[3]) ] -> return_range

range_iter <- iter(return_range)

annualreturn <- function(entry_year,exit_year,portfolio_value){
  repeat {
    print(portfolio_value)
    portfolio_value = portfolio_value+(portfolio_value*nextElem(range_iter))
    if (x == 6){
      break
    }
  }
  
  
  
}


for (i in return_range){
  yr_gain = portfolio_input * i  
  yr_total = portfolio_input + yr_gain
  
}
  
for(i in 2:nrows){
  # Calculate returns for each row
  data_maruti$sreturnsloop[i] <- data_maruti$diffClose[i]/data_maruti$Close[i-1]
}
  


it <- iter(yearly_return_w_inflation$real_return)


# create a function to calculate the return from x year to y year

annualreturn <- function(entry_year,exit_year, symbol){
      
}




# generate the matrix of values for all x,y mappings where y > x



# generate ggplot2 heatmap

y <- c("1950","1950","1950","1951","1951","1952") %>% as.integer()
x <- c("1951","1952","1953","1952","1953","1953") %>% as.integer()
return <- c(0.02,-0.02,0.04,-0.02,0.02,0.06)

example <- data.frame(x,y,return,stringsAsFactors = FALSE)

ggplot(example, aes(x, y)) + 
    geom_tile(aes(fill = return), colour = "white") + 
    scale_fill_gradient2(low = "indianred4",mid= "lemonchiffon3",  high = "darkolivegreen4") +
    scale_y_reverse()
