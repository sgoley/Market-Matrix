library(tidyquant)
library(magrittr)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(quantmod)

setwd('D:/Docs/GitHub/Market-Matrix/')

# cumulative returns function:

cumulative_return <- function(entry_year,exit_year,ticker){
      price_data <- tq_get(ticker,
                       from = paste(entry_year,'-01-01',sep = ''),
                       to = paste(exit_year,'-12-31',sep = ''),
                       get = 'stock.prices')
      wts = c(1.0)
      ret_data <- price_data %>%
        group_by(symbol) %>%
        tq_transmute(select = adjusted,
                     mutate_fun = periodReturn,
                     period = "yearly",
                     col_rename = "ret")
      wts_tbl <- tibble(symbol = ticker,
                        wts = wts)
      ret_data <- left_join(ret_data,wts_tbl, by = 'symbol')
      ret_data <- ret_data %>%
        mutate(wt_return = wts * ret)
      
      port_ret <- ret_data %>%
        group_by(date) %>%
        summarise(port_ret = sum(wt_return))
      
      return( mean(port_ret$port_ret) )
}

# example values:

 x_to_x <- cumulative_return(1989,1989,"^GSPC")
 x_to_y <- cumulative_return(1950,1990,"^GSPC")

# create return values matrix:

enter <- seq(from = 1965, to = 1985, by = 1) %>% as.integer()
exit <- seq(from = 1965, to = 1985, by = 1) %>% as.integer()

cross_join <- crossing(enter,exit)
cross_join %<>% filter(enter <= exit)

return <- mapply(cumulative_return,cross_join$enter,cross_join$exit,"^GSPC")


cross_join$return <- return
cross_join$return_100 <- return * 100

# graphing with y descending order, x ascending order:

plot <- ggplot(cross_join, aes(exit, enter)) + 
        geom_tile(aes(fill = return_100), colour = "white") + 
        coord_equal() +
        scale_fill_gradient2(low = "indianred4",mid= "lemonchiffon3",  high = "darkolivegreen4") +
        scale_y_reverse()

ggplotly(plot)
