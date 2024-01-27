library(tidyverse)
library(hrbrthemes)

spike_regs <- data.frame(regs = c(sample.int(1e4, 11),18000),
                         date = seq.Date(from =as.Date('2023-02-01'), to = as.Date('2024-01-01'), by = 'month')
                         )


spike_regs %>% 
  ggplot(aes(x = date, y= regs)) +
  geom_line() +
  hrbrthemes::theme_ipsum_rc()+
  labs(title = 'Registration count for Partner X*',
       subtitle = 'Aggregated by Month',
       x = NULL,
       y = '# New Users',
       caption = '*Fake data'
       ) +
  scale_y_continuous(labels = scales::comma_format()) +
  scale_x_date(date_labels = '%y-%m-01')

ggsave('reg_count_plot.png', width = 8, height = 5)

# https://sqlfiddle.com/sql-server/online-compiler?id=6772f203-d29e-44b9-a98c-4c155957bbdb


# bot separation ----------------------------------------------------------

bot_registrations_clean <- read_csv('data/bot_registrations_clean.csv')
bot_registrations_clean %>% 
  mutate(is_bot = str_detect(email, stringr::str_to_lower(last_name))) %>% 
  count(registration_date,is_bot) %>% 
  arrange(registration_date) %>% 
  mutate(is_bot = factor(is_bot, levels = c("TRUE", "FALSE"))) %>% 
  ggplot(aes(x = registration_date, y= n, fill = is_bot))+
    geom_col() +
    scale_fill_manual(values = c('#32408F', 'gray55'),name = 'Bot Group') +
    hrbrthemes::theme_ipsum_rc() +
  theme(
    legend.position = 'top',
    legend.text = element_text(size = 10),
    legend.key.size = unit(4, 'mm'),
    legend.key.width = unit(6, 'mm')
  ) +
  labs(x = 'Date',
       y = '# Users',
       title = 'Bot Registration out of all Users'
      )

ggsave('reg_bots_plot.png', width = 8, height = 5)

