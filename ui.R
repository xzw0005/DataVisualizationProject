#setwd('D:\\@Auburn\\2016Spring\\INSY7970_DataVisualization\\projects\\ShinyStock')
library(markdown)

shinyUI(navbarPage("Stock Market Trend Prediction and Analysis Tool",
            tabPanel("Stock Prediction",
                sidebarLayout(
                    sidebarPanel(
                        helpText("Select a stock to examine. Information will be collected 
                                 from yahoo finance, wikitrend, google, and so forth."),
                        textInput(inputId = "symb", label = "Please enter the name of stock:", value = "AAPL"),
                        textInput(inputId = "related", label = "Please enter related terms:", value = "iPhone, iPad, Macbook"),
                        dateInput(inputId = "date", label = "Please choose the date you want to predict trend: ", value = Sys.Date()+1),
                        sliderInput("nYear", "How many years of historical data you want to examine:",min = 1, max = 15, value = 1),
                        actionButton(inputId = "go", label = "Update")
                    ),
                    mainPanel(
                        h3(textOutput("text")),
                        h1(textOutput("result")),
                        h3(helpText("\nHistorical Data from Yahoo Finance")),
                        plotOutput("tempPlotYahoo"),
                        h4(helpText("We have trained 4 different kernels of Supported Vector Machine, 
                                    based on the result of our paper. 
                                    And the best model we chose for this prediction is as follows:")),
                        verbatimTextOutput("modSummary")
                    )
                )
            ),
            tabPanel("Yahoo Finance Trend",
                plotOutput("yahooPlot"),
                verbatimTextOutput("yahooSummary")         
            ),
            tabPanel("WikiTrend Data",
                verbatimTextOutput("fullSummary"),       
                plotOutput("wikiPlot"),
                verbatimTextOutput("wikiSummary")         
            ),
            
            tabPanel("Stock Returns V.S. Cloudness",
                sidebarLayout(
                    sidebarPanel(
#                         selectInput("yearSelectInput", label = h3("Select the years to examine:"), 
#                                     choices = list("2006" = "2006", "2007" = "2007", "2008" = "2008", "2009" = "2009", "2010" = "2010", "2011" = "2011", "2012" = "2012", "2013" = "2013", "2014" = "2014", "2015" = "2015"), selected = 1),
#                         actionButton(inputId = "goYear", label = "Update")
                        checkboxGroupInput("yearCheckGroup", label = h3("Select the years to examine:"), 
                                       choices = list("2006" = "2006", "2007" = "2007", "2008" = "2008", "2009" = "2009", "2010" = "2010", "2011" = "2011", "2012" = "2012", "2013" = "2013", "2014" = "2014", "2015" = "2015"), selected = 1),
                        actionButton(inputId = "goYear", label = "Update")
                    ),
                    mainPanel(
                        h1("Nasdaq"),
                        plotOutput("plotByYearNasdaq"),
                        h1("S&P 500"), 
                        plotOutput("plotByYearSP500")
                    )
                )
            ),            

            
            tabPanel("Stock Returns Over Years (2006-2015)",
                     sidebarLayout(
                         sidebarPanel(
                             checkboxGroupInput("cloudyCheckGroup", label = h3("Select the cloudness levels to examine:"), 
                                                choices = list("0" = "0", "1" = "1", "2" = "2", "3" = "3", "4" = "4", "5" = "5", "6" = "6", "7" = "7"), selected = 1),
                             actionButton(inputId = "goCloudy", label = "Update")
                         ),
                         mainPanel(
                             h1("Nasdaq"),
                             plotOutput("plotByCloudyNasdaq"),
                             h1("S&P 500"), 
                             plotOutput("plotByCloudySP500")
                         )
                     )
            ),                           
            
        navbarMenu("More",
            tabPanel("more1",
                includeMarkdown("haha.md")
            ),
            tabPanel("more2",
                includeMarkdown("haha2.md")
            )
        )
    )
)