#Api key to get get data from US Census Bureau
Sys.setenv(CENSUS_KEY="bdf241d832496d2290428bf2b45f426945f41554")
Sys.getenv("CENSUS_KEY")
census_api_key("bdf241d832496d2290428bf2b45f426945f41554")

install.packages("censusapi")
install.packages("dplyr")
install.packages("vtable")
install.packages("sjPlot")
install.packages("tidycensus")
install.packages("tidyverse")
install.packages("conflicted")
install.packages("stringr")

library(censusapi)
library(dplyr)
library(vtable)
library(sjPlot)
library(tidycensus)
library(tidyverse)
library(conflicted)
library(stringr)

#get_pums function downloads the data 

PUMS19 <- get_pums(
  variables = c("TYPE",
                "BLD",
                "TEN",
                "POBP",
                "ENG",
                "SCHL",
                "FOD1P",
                "HHL",
                "SERIALNO",
                "SPORDER",
                "AGEP",
                "SEX",
                "CIT",
                "RAC1P",
                "COW",
                "OCCP",
                "WKHP",
                "PERNP",
                "JWMNP",
                "JWTRNS",
                "DIS",
                "HISPEED",
                "NOC",
                "NR"),
  state = "all",
  survey = "acs1",
  year = 2019
)

PUMS21 <- get_pums(
  variables = c("TYPEHUGQ",
                "BLD",
                "TEN",
                "POBP",
                "ENG",
                "SCHL",
                "FOD1P",
                "HHL",
                "SERIALNO",
                "SPORDER",
                "AGEP",
                "SEX",
                "CIT",
                "RAC1P",
                "COW",
                "OCCP",
                "WKHP",
                "PERNP",
                "JWMNP",
                "JWTRNS",
                "DIS",
                "HISPEED",
                "NOC",
                "NR"),
  state = "all",
  survey = "acs1",
  year = 2021
)


#Rename the type variable because it has a different name in 2019 and 2021 
colnames(PUMS21)[11] ="TYPE"

#Add a year variable to differentiate between 2019 and 2021
PUMS19$YEAR<-2019
PUMS21$YEAR<-2021

#Combines 2019 and 2021 data into one object
PUMS19_21 <- rbind(PUMS19,PUMS21)

#remove 0009 values at that means person is unemployed
PUMS19_21 <- mutate(PUMS19_21, OCCP = na_if(OCCP,'0009'))

# remove -1 values in number of children variable as that means the house is empty
PUMS19_21 <- mutate(PUMS19_21, NOC = na_if(NOC,-1))

#Converts character variables to numerical
PUMS19_21$OCCP <- as.numeric(PUMS19_21$OCCP)
PUMS19_21$NOC <- as.numeric(PUMS19_21$NOC)
PUMS19_21$AGEP <- as.numeric(PUMS19_21$AGEP)
PUMS19_21$JWMNP <- as.numeric(PUMS19_21$JWMNP)
PUMS19_21$WKHP <- as.numeric(PUMS19_21$WKHP)
PUMS19_21$PERNP <- as.numeric(PUMS19_21$PERNP)
PUMS19_21$SCHL <- as.numeric(PUMS19_21$SCHL)

#Recodes variables as binary 
PUMS19_21$DIS <- ifelse(PUMS19_21$DIS == '1', 1, 0)
PUMS19_21$NR <- ifelse(PUMS19_21$NR == '1', 1, 0)
PUMS19_21$HISPEED <- ifelse(PUMS19_21$HISPEED == '1', 1, 0)

#Mutates dataset to remove unemployed and underaged individuals
workers19_21 <- PUMS19_21[PUMS19_21$COW != '0' & 
                            PUMS19_21$PERNP > 0 & 
                            PUMS19_21$TYPE == '1' &
                            PUMS19_21$JWTRNS != '0',]

#Creates a binary variable with 1 for people that work from home and 0 for those who don't
workers19_21$WFH <- ifelse(PUMS19_21$JWTRNS == '11', 1, 0)

#tappy function gives mean WFH rate by state
means_by_value <- tapply(Pums19$WFH, Pums19$ST, mean)
means_by_value
