pcol <- c("CountryName", "CountryCode", "RegionName", "RegionCode",
          "Jurisdiction", "Date","C1_School.closing", "C1_Flag",
          "C2_Workplace.closing","C2_Flag", "C3_Cancel.public.events", "C3_Flag",
          "C4_Restrictions.on.gatherings","C4_Flag", "C5_Close.public.transport",
          "C5_Flag", "C6_Stay.at.home.requirements",
          "C6_Flag","C7_Restrictions.on.internal.movement", "C7_Flag",
          "C8_International.travel.controls", "E1_Income.support","E1_Flag",
          "E2_Debt.contract.relief", "E3_Fiscal.measures", "E4_International.support",
          "H1_Public.information.campaigns", "H1_Flag", "H2_Testing.policy",
          "H3_Contact.tracing",
          "H4_Emergency.investment.in.healthcare", "H5_Investment.in.vaccines",
          "H6_Facial.Coverings", "H6_Flag", "H7_Vaccination.policy", "H7_Flag",
          "M1_Wildcard", "ConfirmedCases", "DailyCases",
          "ConfirmedDeaths", "DailyDeaths",
          "StringencyIndex", "StringencyIndexForDisplay", "StringencyLegacyIndex",
          "StringencyLegacyIndexForDisplay", "GovernmentResponseIndex",
          "GovernmentResponseIndexForDisplay", "ContainmentHealthIndex",
          "ContainmentHealthIndexForDisplay", "EconomicSupportIndex",
          "EconomicSupportIndexForDisplay")
profilecol <- as.data.frame(matrix(ncol=length(pcol), nrow=0,
                                   dimnames=list(NULL, pcol)))



url <- "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv"
Covid_Gov_res <- read.csv(url, header=TRUE)
WorldPop <- read.csv("WorldPop.csv", header=TRUE)
WorldPop <- WorldPop[, c("Country.Name", "Country.Code", "X2019")]
Countrycodes <- unique(Covid_Gov_res$CountryCode)
Countrycodes <- Countrycodes[! Countrycodes %in% c("TKM", "TON", "RKS", "TWN", "AND", "BHR", "QAT", "SMR")]


CountryGroupProfile <- function(codelist) {
  library(lubridate)
  library(zoo)
  #profile <- read.csv("profilecol.csv", header=TRUE)
  profile <- profilecol
  for(code in codelist) {
    uniprofile <- Covid_Gov_res[Covid_Gov_res$CountryCode==code &
                                  Covid_Gov_res$Jurisdiction=="NAT_TOTAL", ]
    Cpop <- WorldPop[WorldPop$Country.Code == code, c("X2019")] /100000
    # calculate daily cases (rolling mean 7 days)
    daily <- diff(uniprofile$ConfirmedCases)
    daily <- append(daily, values=0,0)
    daily[daily < 0] <- 0
    daily <- rollmean(daily, 7)
    daily <- append(daily, values = rep(0,6),0)
    #calculate daily cases per 100.000 inhabitants
    daily <- daily / Cpop
    uniprofile$DailyCases <- daily
    # calculate daily deaths  (rolling mean 7 days)
    dailydec <- diff(uniprofile$ConfirmedDeaths)
    dailydec <- append(dailydec,values=0,0)
    dailydec[dailydec < 0] <- 0
    dailydec <- rollmean(dailydec, 7)
    dailydec <- append(dailydec, values=rep(0,6),0)
    # calculate daily deaths per million inhabitants
    dailydec <- dailydec / Cpop * 10
    uniprofile$DailyDeaths <- dailydec
    # calculate confirmed deaths per 100.000 inhabitants
    uniprofile$ConfirmedDeaths <- uniprofile$ConfirmedDeaths / Cpop
    # calculate confirmed cases per 100.000 inh
    uniprofile$ConfirmedCases <- uniprofile$ConfirmedCases / Cpop
    uniprofile$Date <- ymd(uniprofile$Date)
    uniprofile <- uniprofile[, c(1:38, 50, 39, 51, 40:49)]
    profile <- rbind(profile, uniprofile)
  }
  return(profile)
}
