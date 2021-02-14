# Covid-tracker
Real time Covid stats.

An interactive app to retrieve daily and total confirmed Covid cases and deaths for 175 countries.
We combined the Oxford Covid-19 Government response tracker dataset and World Bank World Population data to calculate daily cases per 100K inhabitants
and daily deaths per million inhabitants as rolling 7 day averages. Total confirmed cases and total confirmed deaths are likewise calculated on a per 100K base.
We provide a visual display of these calculations for selected countries. Data set constructions and calculations were performed in the R environment for statistical computing.
Graphical representations were also developed in R. We developed an interactive Rshiny app and we made use of the shinyapps.io platform to make the app available online.
https://pbostyn.shinyapps.io/covidstats/
