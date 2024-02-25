# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(stringi)



# Data Import
citations <- stri_read_lines("../data/citations.txt", encoding = 'Windows-1252')
citations_txt <- citations[!stri_isempty(citations)]
length(citations)-length(citations_txt)
mean(str_length(citations_txt))

# Data Cleaning
view(sample_n(citations_tbl, 20))

citations_tbl <- tibble(line=1:length(citations_txt),cite=citations_txt) %>%
  mutate(cite = str_replace_all(cite, "[\'\"]", replacement = "")) %>%
  mutate(year = str_extract(cite, "\\d{4}")) %>%
  mutate(page_start = str_extract(cite, pattern = "\\d+(?=-\\d+)")) %>% 
  mutate(perf_ref = str_detect(cite, pattern = regex("performance", ignore_case = TRUE))) %>%
  mutate(title = str_match(cite, pattern = "\\)\\.\\s([^\\.]+[.?!])")[,2]) %>%
  mutate(first_author = str_match(cite, pattern = "\\b(\\w+,\\s[A-Z](?:\\.\\s*[A-Z])*\\.)")[,2])

sum(!is.na(citations_tbl$first_author))