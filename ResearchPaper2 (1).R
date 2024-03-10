install.packages("dplyr")
install.packages("vtable")
install.packages("sjPlot")
install.packages("tidycensus")
install.packages("tidyverse")
install.packages("conflicted")
install.packages("stringr")

library(dplyr)
library(vtable)
library(sjPlot)
library(tidycensus)
library(tidyverse)
library(conflicted)
library(stringr)

install.packages("censusapi")
library(censusapi)

Sys.setenv(CENSUS_KEY="f9697ffcc9551a0d78c59852e4690bb3d4d32886")
Sys.getenv("CENSUS_KEY")
census_api_key("f9697ffcc9551a0d78c59852e4690bb3d4d32886")

pums21 <- getCensus(
  name = "acs/acs1/pums",
  vintage = 2021,
  vars = c("PERNP",
           "SEX",
           "ENG",
           "SCHL"),
  
  region = "public use microdata area:*",
  regionin = "state:06")

pums21$PERNP <- as.numeric(pums21$PERNP)
pums21$SEX <- as.numeric(pums21$SEX)
pums21$SCHL <- as.numeric(pums21$SCHL)
pums21$ENG <- as.numeric(pums21$ENG)

#tab_xtab(var.row = pums21$PERNP, 
         #var.col = pums21$SCHL, 
         #title = "2021", show.col.prc = TRUE)

pums21$BachorHigher <- ifelse(pums21$SCHL >= '21', 1, 0)
pums21$HSorGED <- ifelse(pums21$SCHL == '16' & pums21$SCHL == '17', 1, 0)
pums21$BelowHS <- ifelse(pums21$SCHL < '16', 1, 0)

pums21$SixFigures <- ifelse(pums21$PERNP >= '100000', 1, 0)
pums21$AvgIncome <- ifelse(pums21$PERNP > '70000' & pums21$PERNP < '75000', 1, 0)
pums21$InDebt <- ifelse(pums21$PERNP < '0', 1, 0)

pums21$IsMale <- ifelse(pums21$SEX == '1', 1, 0)
pums21$IsFemale <- ifelse(pums21$SEX == '2', 1, 0)

pums21$SpeaksEnglish <- ifelse(pums21$ENG == '1' & pums21$ENG == '2', 1, 0)
pums21$LittleEnglish <- ifelse(pums21$ENG == '3' & pums21$ENG == '4', 1, 0)

Data <- subset(pums21, select = -c(SpeaksEnglish))

Data$LittleEnglish <- ifelse(Data$ENG == '3' & pums21$ENG == '4', 1, 0)

logit <- glm(SixFigures ~ SpeaksEnglish + IsMale + BachorHigher, family=binomial(link="logit"), data = Data)
tab_model(logit, digits = 4)












#workers19_21 <- PUMS19_21[PUMS19_21$COW != '0' & 
                            #PUMS19_21$PERNP > 0 & 
                            #PUMS19_21$TYPE == '1' &
                            #PUMS19_21$JWTRNS != '0',]

#pums19$SFR <- ifelse(pums19$BLD %in% c("2","3"), 1, 0)
#pums19$SEX <- as.factor(pums19$SEX)

#mean(workers19_21[workers19_21$YEAR==2019,]$WFH)
#mean(workers19_21[workers19_21$YEAR==2021,]$WFH)


