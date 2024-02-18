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

workers19_21$WFH <- ifelse(workers19_21$JWTRNS == '11', 1, 0)

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

pums21 <- getCensus(
  name = "acs/acs1/pums",
  vintage = 2021,
  vars = c("TYPEHUGQ",
           "BLD",
           "POBP",
           "TEN",
           "HHL",
           "SERIALNO",
           "SPORDER",
           "AGEP",
           "SEX",
           "CIT",
           "RAC1P",
           "COW",
           "ENG",
           "SCHL",
           "OCCP",
           "WKHP",
           "PERNP",
           "JWMNP",
           "JWTRNS",
           "DIS",
           "HISPEED",
           "NOC",
           "NR"),
  
  region = "public use microdata area:*",
  regionin = "state:06")

colnames(PUMS21)[11] ="TYPE"

PUMS19$YEAR<-2019
PUMS21$YEAR<-2021

PUMS19_21 <- rbind(PUMS19,PUMS21 )

tab_xtab(var.row = POB_2019_sorted$POBP, 
         var.col = PUMS2019_sorted$WFH, 
         title = "2019 ", show.col.prc = TRUE,)

workers19_21$WFH <- ifelse(PUMS19_21$JWTRNS == '11', 1, 0)

PUMS19_21 <- mutate(PUMS19_21, OCCP = na_if(OCCP,'0009'))
PUMS19_21 <- mutate(PUMS19_21, NOC = na_if(NOC,-1))

PUMS19_21$OCCP <- as.numeric(PUMS19_21$OCCP)
PUMS19_21$NOC <- as.numeric(PUMS19_21$NOC)
PUMS19_21$AGEP <- as.numeric(PUMS19_21$AGEP)
PUMS19_21$JWMNP <- as.numeric(PUMS19_21$JWMNP)
PUMS19_21$WKHP <- as.numeric(PUMS19_21$WKHP)
PUMS19_21$PERNP <- as.numeric(PUMS19_21$PERNP)
PUMS19_21$SCHL <- as.numeric(PUMS19_21$SCHL)

PUMS19_21$DIS <- ifelse(PUMS19_21$DIS == '1', 1, 0)
PUMS19_21$NR <- ifelse(PUMS19_21$NR == '1', 1, 0)
PUMS19_21$HISPEED <- ifelse(PUMS19_21$HISPEED == '1', 1, 0)


workers19_21 <- PUMS19_21[PUMS19_21$COW != '0' & 
                            PUMS19_21$PERNP > 0 & 
                            PUMS19_21$TYPE == '1' &
                            PUMS19_21$JWTRNS != '0',]

pums19$Owner <- ifelse(pums19$TEN %in% c("1","2"), 1, 0)

pums19$SFR <- ifelse(pums19$BLD %in% c("2","3"), 1, 0)

pums19$BachorHigher <- ifelse(pums19$SCHL > 20, 1, 0)

pums19$SEX <- as.factor(pums19$SEX)




pums21$MGRBUSFIN<- ifelse(pums21$OCCP<1000,1,0)
pums21$SCIENG<- ifelse(pums21$OCCP>1300 & pums21$OCCP<2000,1,0)
pums21$ENT<- ifelse(pums21$OCCP>=2600 & pums21$OCCP<3000,1,0)
pums21$MEDHLS<- ifelse(pums21$OCCP>=3000 & pums21$OCCP<3700,1,0)
pums21$EAT<- ifelse(pums21$OCCP>=4000 & pums21$OCCP<4200,1,0)
pums21$CON<- ifelse(pums21$OCCP>=6200 & pums21$OCCP<6800,1,0)

pums19$MGRBUSFIN<- ifelse(pums19$OCCP<1000,1,0)
pums19$ENT<- ifelse(pums19$OCCP>=2600 & pums19$OCCP<3000,1,0)
pums19$MEDHLS<- ifelse(pums19$OCCP>=3000 & pums19$OCCP<3700,1,0)
pums19$EAT<- ifelse(pums19$OCCP>=4000 & pums19$OCCP<4200,1,0)
pums19$CON<- ifelse(pums19$OCCP>=6200 & pums19$OCCP<6800,1,0)



sumtable(workers21 & workers19)


mean(workers19_21[workers19_21$YEAR==2019,]$WFH)
mean(workers19_21[workers19_21$YEAR==2021,]$WFH)

mean(workers19_21[workers19_21$YEAR==2019 & workers19_21$ST=="06",]$WFH)
mean(workers19_21[workers19_21$YEAR==2021 & workers19_21$ST=="06",]$WFH)

workers19_21$WFH <- ifelse(workers19_21$JWTRNS == '11', 1, 0)

tab_xtab(var.row = workers19_21$YEAR, 
         var.col = workers19_21$WFH, 
         title = "Diff", show.row.prc = TRUE)

tab_xtab(var.row = workers19_21[workers19_21$ST=="06",]$YEAR, 
         var.col = workers19_21[workers19_21$ST=="06",]$WFH, 
         title = "Diff", show.row.prc = TRUE)


tab_xtab(var.row = workers19_21[workers19_21$ST=="06",]$YEAR, 
         var.col = workers19_21[workers19_21$ST=="06",]$WFH, 
         title = "Diff", show.row.prc = TRUE)

tab_xtab(var.row = workers19_21[workers19_21$ST=="48",]$YEAR, 
         var.col = workers19_21[workers19_21$ST=="48",]$WFH, 
         title = "Diff", show.row.prc = TRUE)


tab_xtab(var.row = workers19_21[workers19_21$YEAR==2019,]$CIT, 
         var.col = workers19_21[workers19_21$YEAR==2019,]$WFH, 
         title = "Diff", show.row.prc = TRUE)

tab_xtab(var.row = workers19_21[workers19_21$YEAR==2021,]$CIT, 
         var.col = workers19_21[workers19_21$YEAR==2021,]$WFH, 
         title = "Diff", show.row.prc = TRUE)

tab_xtab(var.row = workers19_21[workers19_21$YEAR==2019 & workers19_21$ST=="06",]$CIT, 
         var.col = workers19_21[workers19_21$YEAR==2019 & workers19_21$ST=="06",]$WFH, 
         title = "Diff", show.row.prc = TRUE)

tab_xtab(var.row = workers19_21[workers19_21$YEAR==2021 & workers19_21$ST=="06",]$CIT, 
         var.col = workers19_21[workers19_21$YEAR==2021 & workers19_21$ST=="06",]$WFH, 
         title = "Diff", show.row.prc = TRUE)

PUMS19_21$OCCP <- as.numeric(PUMS19_21$OCCP)

workers19_21$ST2 <- str_remove(ST, "^0+")

state<-c(1:5)
state

for (x in state) {
  tab_xtab(var.row = workers19_21[workers19_21$YEAR==2019 & workers19_21$ST=="",]$CIT, 
           var.col = workers19_21[workers19_21$YEAR==2019 & workers19_21$ST=="",]$WFH, 
           title = "Diff", show.row.prc = TRUE)
}

st<-list(1:60)
st

my_function <- function(x) { 
  california <- workers19_21[workers19_21$ST==st,]
}

my_function(st)

sapply(st,my_function)
sapply(california, mean)
