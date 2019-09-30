
library(magrittr)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)


# read inflation data
us_inflation <- read_csv("files/us_inflation.csv", col_types = cols(YEAR = col_number()))

us_inflation %>%
  gather(key = 'month', value = 'monthly_inflation_rate', JAN:DEC) -> us_inflation_tidy


# read in source data to calculate returns in range 1950-2019

SP500 <- read_csv("files/^GSPC.csv", col_types = cols(Date = col_date(format = "%m/%d/%Y")))

SP500 %>%
  filter(!is.na(Date)) %>%
  select(date=Date,adj_close=`Adj Close`) -> df

df %>%
  mutate(lag = lag(adj_close)) %>%
  mutate(close_pct_change = (adj_close - lag) / lag) %>%
  mutate(year = format(date,"%Y") )-> df

# return w/ inflation [((1 + return) / (1 + inflation)) - 1] x 100

# build x,y maps

df$date %>% format("%Y") %>% unique() -> df_years
df_years[-length(df_years)] -> df_years_x
df_years[-1] -> df_years_y

# create a function to calculate the return from x year to y year

annualreturn <- function(xyear,yyear){
  
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
