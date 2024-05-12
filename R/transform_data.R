library(dplyr)
library(lubridate)


read_sheet <- function(file_name, sheet_name) {
    meta <- readxl::read_xlsx(file_name,
        sheet = sheet_name,
        n_max = 9,
        col_names = FALSE
    )
    ap <- unlist(meta[1, 2])
    dt <- readxl::read_xlsx(file_name, sheet = sheet_name, skip = 9)
    colnames(dt) <- c(
        "kandidatas", "apylinkėse",
        "paštu", "viso", "proc_galiojantys", "proc_viso"
    )
    dt <- dt %>%
        mutate(timestamp = ymd_hms(paste(
            "2024-05-12",
            gsub("_", ":", sheet_name), ":00"
        ))) %>%
        mutate(apylinkes = ap)
    dt <- dt %>% filter(kandidatas != "Iš viso")
    dt
}

shl <- readxl::excel_sheets("data/prezidento_rinkimai_2024.xlsx")

rdt <- mapply(function(shn) read_sheet("data/prezidento_rinkimai_2024.xlsx", shn),
    shl,
    SIMPLIFY = FALSE
) %>% bind_rows()

rdt %>%
    arrange(kandidatas, timestamp) %>%
    write.csv("data/rezultatai_laike.csv", row.names = FALSE)
