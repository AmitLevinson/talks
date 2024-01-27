library(tidyverse)
library(hrbrthemes)

regs_raw <- read_csv('data/bot_registrations_raw.csv')
good_pop <- regs_raw %>% 
  filter(id >= 701) %>% 
  mutate(
    email = paste0(str_extract(email, '.+(?=@)'),
                   '@',
                   sample(c('gmail.com', 'yahoo.com', 'hotmail.com'), size = 200, replace = T)
    )
  )

clean_pop <- regs_raw %>% 
  filter(id <= 700) %>% 
  rbind(good_pop) %>% 
  mutate(registration_date = as.Date(registration_time, format = '%m/%d/%Y')) %>% 
  arrange(registration_date) %>% 
  select(-registration_time, -id)

clean_pop %>% 
  write_csv('data/bot_registrations_clean.csv')



# Money Laundering --------------------------------------------------------


user_ids <- sample.int(n = 1e4, size = 150, replace = T)
bad_u <- sample(user_ids, size = 20, replace = FALSE)
good_u <- user_ids[!user_ids %in% bad_u]
payment_dates <- seq(as.POSIXct('2023/03/01'), as.POSIXct('2023/03/3'), by="15 mins")


bad_df <- data.frame(from = bad_u,
           to = lead(bad_u),
           amount = round(200 - (1:20) / 2),
           rowid = c(1:20)
           )

good_df <- data.frame(
  from = sample(good_u, size = 150, replace = T),
  to = sample(good_u, size = 150, replace = T),
  amount = sample(c(150:300), size = 150, replace = T),
  rowid = sample.int(20, size = 150, replace = T)
) %>% 
  filter(from != to)
  
final_df <- rbind(bad_df, good_df) %>% 
  arrange(rowid) %>% 
  select(-rowid) %>% 
  mutate(payment_date = (payment_dates[1:nrow(.)]))


final_df %>% 
  write_csv('data/ml.csv')
