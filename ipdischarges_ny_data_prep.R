## DO NOT RUN ME! NOT NEEDED FOR THE ASSIGNMENT.

## This data prep file is just so you can see a typical data prep file


library(dplyr)
library(readr)

## Read in full discharges dataset

ipdischarges_ny <- read_csv("./ipdischarges_ny.csv")


## Replace NAs with "unknown" for a few fields

ipdischarges_ny <-  ipdischarges_ny %>% 
  mutate(`APR Severity of Illness Description` = 
           replace(`APR Severity of Illness Description`, 
                   is.na(`APR Severity of Illness Description`), "unknown"))

ipdischarges_ny <-  ipdischarges_ny %>% 
  mutate(`ARP Risk of Mortality` = 
           replace(`APR Risk of Mortality`, 
                   is.na(`APR Risk of Mortality`), "unknown"))

## Data type changes and fixes

# Convert from chr to factor
ipdischarges_ny$`Health Service Area` <- as.factor(ipdischarges_ny$`Health Service Area`)
ipdischarges_ny$`Hospital County` <- as.factor(ipdischarges_ny$`Hospital County`)
ipdischarges_ny$`Facility Id` <- as.factor(ipdischarges_ny$`Facility Id`)
ipdischarges_ny$`Facility Name` <- as.factor(ipdischarges_ny$`Facility Name`)
ipdischarges_ny$`Age Group` <- as.factor(ipdischarges_ny$`Age Group`)
ipdischarges_ny$`Zip Code - 3 digits` <- as.factor(ipdischarges_ny$`Zip Code - 3 digits`)
ipdischarges_ny$`Gender` <- as.factor(ipdischarges_ny$`Gender`)
ipdischarges_ny$`Race` <- as.factor(ipdischarges_ny$`Race`)
ipdischarges_ny$`Ethnicity` <- as.factor(ipdischarges_ny$`Ethnicity`)
ipdischarges_ny$`Type of Admission` <- as.factor(ipdischarges_ny$`Type of Admission`)
ipdischarges_ny$`Patient Disposition` <- as.factor(ipdischarges_ny$`Patient Disposition`)

ipdischarges_ny$`CCS Diagnosis Code` <- as.factor(ipdischarges_ny$`CCS Diagnosis Code`)
ipdischarges_ny$`CCS Diagnosis Description` <- 
  as.factor(ipdischarges_ny$`CCS Diagnosis Description`)
ipdischarges_ny$`CCS Procedure Code` <- 
  as.factor(ipdischarges_ny$`CCS Procedure Code`)
ipdischarges_ny$`CCS Procedure Description` <- 
  as.factor(ipdischarges_ny$`CCS Procedure Description`)

ipdischarges_ny$`APR DRG Code` <- as.factor(ipdischarges_ny$`APR DRG Code`)
ipdischarges_ny$`APR DRG Description` <- as.factor(ipdischarges_ny$`APR DRG Description`)

ipdischarges_ny$`APR MDC Code` <- as.factor(ipdischarges_ny$`APR MDC Code`)
ipdischarges_ny$`APR MDC Description` <- as.factor(ipdischarges_ny$`APR MDC Description`)

# Convert to ordered factor

ipdischarges_ny$`Age Group` <- 
  factor(ipdischarges_ny$`Age Group`,
         ordered=TRUE,levels=c("0 to 17", "18 to 29",
                               "30 to 49", "50 to 69", "70 or Older"))
# Convert to factor
ipdischarges_ny$`APR Severity of Illness Code` <- 
  as.factor(ipdischarges_ny$`APR Severity of Illness Code`)

ipdischarges_ny$`APR Severity of Illness Description` <- 
  as.factor(ipdischarges_ny$`APR Severity of Illness Description`)

ipdischarges_ny$`APR Risk of Mortality` <- 
  as.factor(ipdischarges_ny$`APR Risk of Mortality`)

ipdischarges_ny$`APR Medical Surgical Description` <- 
  as.factor(ipdischarges_ny$`APR Medical Surgical Description`)

ipdischarges_ny$`Payment Typology 1` <- as.factor(ipdischarges_ny$`Payment Typology 1`)
ipdischarges_ny$`Payment Typology 2` <- as.factor(ipdischarges_ny$`Payment Typology 2`)
ipdischarges_ny$`Payment Typology 3` <- as.factor(ipdischarges_ny$`Payment Typology 3`)

ipdischarges_ny$`Attending Provider License Number` <- as.factor(ipdischarges_ny$`Attending Provider License Number`)
ipdischarges_ny$`Operating Provider License Number` <- as.factor(ipdischarges_ny$`Operating Provider License Number`)
ipdischarges_ny$`Other Provider License Number` <- as.factor(ipdischarges_ny$`Other Provider License Number`)

ipdischarges_ny$`Emergency Department Indicator` <- as.factor(ipdischarges_ny$`Emergency Department Indicator`)

# Convert to numeric
ipdischarges_ny$`Total Charges` <- 
  as.numeric(gsub("\\$", "", ipdischarges_ny$`Total Charges`))

ipdischarges_ny$`Total Costs` <- 
  as.numeric(gsub("\\$", "", ipdischarges_ny$`Total Costs`))

## Remove unneeded fields

ipdischarges_ny <- ipdischarges_ny[,c(1:2,4:13,15:22,24,25,27,36,37)]

## Clean up column names

cur_col_names <- names(ipdischarges_ny)

new_col_names <- gsub(" ", "_", cur_col_names)
new_col_names <- gsub("Diagnosis", "Dx", new_col_names)
new_col_names <- gsub("Procedure", "Proc", new_col_names)
new_col_names <- gsub("Description", "Desc", new_col_names)
new_col_names <- gsub("Operating_Certificate_Number", "Oper_Cert_num", new_col_names)

new_col_names <- gsub("Emergency_Department_Indicator", "ED_Ind", new_col_names)
new_col_names <- gsub("Zip_Code_-_3_digits", "ZipCode", new_col_names)
new_col_names <- gsub("Attending_Provider_License_Number", "Attending_PLN", new_col_names)
new_col_names <- gsub("Operating_Provider_License_Number", "Operating_PLN", new_col_names)

names(ipdischarges_ny) <- new_col_names

## Filter records of interest

# Set filter to just include records from APR_MDC_Code == 4
# and with Total_Costs < 750000 and with Length_of_Stay not NA.

ipd_resp <- ipdischarges_ny %>%
  filter(APR_MDC_Code == 4 & Total_Costs < 750000 & !is.na(Length_of_Stay))

ipd_resp <- ipd_resp[complete.cases(ipd_resp),]
# ipd_resp <- as.data.frame(ipd_resp)
save(ipd_resp,file = "ipd_resp.RData" )
