library(httr)
library(jsonlite)
library(dplyr)
library(lubridate)



response <- GET("https://www.vrk.lt/statiniai/puslapiai/rinkimai/1504/2/2068/rezultatai/rezultataiVienmVrt.json")
oo0 <- content(response, "text", encoding = "UTF-8")
oo <- oo0 %>% fromJSON()

rdt0 <- oo$data$kandidatai

rdt1 <- rdt0 %>% select(-rknd_id, -rknd_v_ar_pats, -rd_lytis, -proc_nuo_dal_rinkeju)

colnames(rdt1) <- c(
    "kandidatas", "apylinkėse", "paštu", "viso",
    "proc_galiojantys", "proc_viso"
)

tmst <- ymd_hms(oo$header$date, tz = "Europe/Vilnius")

rdt2 <- rdt1 %>%
    mutate(timestamp = tmst) %>%
    mutate(
        apylinkes = oo$data$bendraInfo$apylinkiu_sk_pateike,
        proc_rinkeju = oo$data$bendraInfo$pateike_rink_sudaro_proc
    )


nm <- paste0("data/json_data_2024_05_26/clean/rezultatai_", tmst, ".csv")
rdt2 %>% write.csv(file = nm, row.names = FALSE)


nmj <- paste0("data/json_data_2024_05_26/", oo$header$resource, "_", tmst, ".json")

oo0 %>% write_json(nmj)
