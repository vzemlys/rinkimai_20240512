library(dplyr)

fns <- dir("data/json_data_2024_05_26/clean/", full.names = TRUE)

fdt <- lapply(fns, read.csv) %>% bind_rows()

fdt %>%
    arrange(kandidatas, timestamp) %>%
    write.csv("data/rezultatai_laike_2024_05_26.csv", row.names = FALSE)
