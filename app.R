
library(shiny)
source("Groupprofile.R")

ui <- navbarPage("Covid cases and deaths for selected countries",
                 tabPanel("Daily cases",

                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = "varcase",
                                          "select countries",
                                          choices=Countrycodes,
                                          multiple=TRUE)
                            ),
                            # Show a plot 
                            mainPanel(
                              plotOutput(outputId = "casePlot")
                            )
        )
    ),
    
                tabPanel("Daily deaths",
             
             sidebarLayout(
               sidebarPanel(
                 selectInput(inputId = "vardec",
                             "select countries",
                             choices=Countrycodes,
                             multiple=TRUE)
               ),
               # Show a plot 
               mainPanel(
                 plotOutput(outputId = "dailydecPlot")
               )
             )
    ),
    
              tabPanel("Confirmed cases",
             
             sidebarLayout(
               sidebarPanel(
                 selectInput(inputId = "varcasetot",
                             "select countries",
                             choices=Countrycodes,
                             multiple=TRUE)
               ),
               # Show a plot 
               mainPanel(
                 plotOutput(outputId = "casetotPlot")
               )
             )
    ),
    
            tabPanel("Confirmed deaths",
             
             sidebarLayout(
               sidebarPanel(
                 selectInput(inputId = "vardectot",
                             "select countries",
                             choices=Countrycodes,
                             multiple=TRUE)
               ),
               # Show a plot 
               mainPanel(
                 plotOutput(outputId = "dectotPlot")
               )
             )
    )
    
)

# Define server logic 
server <- function(input, output) {
  
  output$casePlot <- renderPlot({
    
    library(ggplot2)
    library(ggthemes)
    
    
    profile <- CountryGroupProfile(input$varcase)
    
    ggplot(data = profile) + aes(x = Date, y = DailyCases, color = CountryCode) +  
      geom_line(size=1.15) + ylab("Daily cases / 100.000 inh.") +
      ggtitle("Daily cases per 100.000 inh.") + 
      scale_color_discrete(name="Country codes") +
      scale_x_date(limits=as.Date(c("2021-01-01", NA)), date_breaks = "4 day",
                   date_labels="%d / %m") + theme_solarized() +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$dailydecPlot <- renderPlot({
    library(ggplot2)
    library(ggthemes)
   
     profile <- CountryGroupProfile(input$vardec)
    
    ggplot(data = profile) + aes(x = Date, y = DailyDeaths, color = CountryCode) +  
      geom_line(size=1.15) + ylab("Daily deaths per million inh.") +
      ggtitle("Daily deaths per million inh.") + 
      scale_color_discrete(name="Country codes") +
      scale_x_date(limits=as.Date(c("2021-01-01", NA)), date_breaks = "4 day",
                   date_labels="%d / %m ") + theme_solarized() +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$casetotPlot <- renderPlot({
    library(ggplot2)
    library(ggthemes)
    
    profile <- CountryGroupProfile(input$varcasetot)
    
    ggplot(data = profile) + aes(x = Date, y = ConfirmedCases, color = CountryCode) +  
      geom_line(size=1.15) + ylab("Confirmed Cases / 100.000 inh.") +
      ggtitle("Confirmed cases per 100.000 inh.") + 
      scale_color_discrete(name="Country codes") +
      scale_x_date(limits=as.Date(c("2020-03-01", NA)), date_breaks = "1 month",
                   date_labels="%d / %m / %Y") + theme_solarized() +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  
  output$dectotPlot <- renderPlot({
    library(ggplot2)
    library(ggthemes)
    
    profile <- CountryGroupProfile(input$vardectot)
    
    ggplot(data = profile) + aes(x = Date, y = ConfirmedDeaths, color = CountryCode) +  
      geom_line(size=1.15) + ylab("Confirmed deaths / 100.000 inh.") +
      ggtitle("Confirmed deaths per 100.000 inh.") + 
      scale_color_discrete(name="Country codes") +
      scale_x_date(limits=as.Date(c("2020-03-01", NA)), date_breaks = "1 month",
                   date_labels="%d / %m / %Y") + theme_solarized() +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
