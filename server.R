# Install and load any needed packages
pkgs = c("shiny", "TTR", "quantmod", "wikipediatrend",
         "caret", "fscaret", "neuralnet", "kernlab", "gmodels", "C50", "nnet")
for (p in pkgs) {
    if (! require(p, character.only = TRUE)) {
        install.packages(p)
    }
    library(p, character.only = TRUE)
}
nasdaq = read.csv("nasdaq.csv")
nasdaq$Stock.return = as.numeric(sub("%", "", nasdaq$Stock.return))

sp = read.csv("sp500.csv")
sp$Stock.return = as.numeric(sub("%", "", sp$Stock.return))
options(warn=-1)

#source("getFullData.R")
source("modTrain.R")
source("helpers.R")

shinyServer(function(input, output, session) {
    nasdaqByYearMean = eventReactive(input$goYear, {
        aggregate(nasdaq[nasdaq$Year %in% input$yearCheckGroup, ]$Stock.return, list(nasdaq[nasdaq$Year %in% input$yearCheckGroup, ]$Cloudiness), mean)   
    })
    
    sp500ByYearMean = eventReactive(input$goYear, {
        aggregate(sp[sp$Year %in% input$yearCheckGroup, ]$Stock.return, list(sp[sp$Year %in% input$yearCheckGroup, ]$Cloudiness), mean)   
    })
    
    
    nasdaqByCloudyMean = eventReactive(input$goCloudy, {
        aggregate(nasdaq[nasdaq$Cloudiness %in% input$cloudyCheckGroup, ]$Stock.return, list(nasdaq[nasdaq$Cloudiness %in% input$cloudyCheckGroup, ]$Year), mean)
    })
    
    sp500ByCloudyMean = eventReactive(input$goCloudy, {
        aggregate(sp[sp$Cloudiness %in% input$cloudyCheckGroup, ]$Stock.return, list(sp[sp$Cloudiness %in% input$cloudyCheckGroup,  ]$Year), mean)
    })
        
    yahooData = eventReactive(input$go, {
        getSymbols(input$symb, src = "yahoo", from = input$date - 365 * input$nYear, to = input$date - 1, auto.assign = FALSE)
    })
    wikiData = eventReactive(input$go, {
        wp_trend(page = c(input$symb, strsplit(gsub(" ", "", input$related), split = ",")[[1]]), 
                 from = input$date - 365, to = input$date)
    })
    term_count = eventReactive(input$go, {length(input$related) +1 }) 

    output$plotByCloudyNasdaq = renderPlot(
        ggplot(data = nasdaqByCloudyMean(), mapping = aes(x = Group.1, y = x)) + geom_line(color = "red", size = 1.5) + labs(list(title = "Mean of Nasdaq Returns Over Years", x = "Year", y = "Mean of Stocks Return (%)")) + geom_hline(yintercept = 0, size = 1, color = "blue", linetype = "dashed") + geom_point(size = 5.5, shape = 16) + theme_bw() + scale_x_continuous(breaks=nasdaqByCloudyMean()$Group.1) 
    )
    
    output$plotByCloudySP500 = renderPlot(
        ggplot(data = sp500ByCloudyMean(), mapping = aes(x = Group.1, y = x)) + geom_line(color = "red", size = 1.5) + labs(list(title = "Mean of S&P 500 Returns Over Years", x = "Year", y = "Mean of Stocks Return (%)")) + geom_hline(yintercept = 0, size = 1, color = "blue", linetype = "dashed") + geom_point(size = 5.5, shape = 16) + theme_bw() + scale_x_continuous(breaks=sp500ByCloudyMean()$Group.1) 
    )    
    
    output$plotByYearNasdaq = renderPlot(
        ggplot(data = nasdaqByYearMean(), mapping = aes(x = Group.1, y = x)) + geom_bar(stat = "identity", color = nasdaqByYearMean()$Group.1) + scale_fill_brewer() + labs(list(title = "Mean of Nasdaq Returns V.S. Cloudiness", x = "Cloudness", y = "Mean of Stocks Return (%)")) + geom_hline(yintercept = 0, size = 1, color = "red") + scale_x_continuous(breaks=nasdaqByYearMean()$Group.1) 
    )

    output$plotByYearSP500 = renderPlot(
        ggplot(data = sp500ByYearMean(), mapping = aes(x = Group.1, y = x)) + geom_bar(stat = "identity", color = sp500ByYearMean()$Group.1) + scale_fill_brewer() + labs(list(title = "Mean of S&P 500 Returns V.S. Cloudiness", x = "Cloudness", y = "Mean of Stocks Return (%)")) + geom_hline(yintercept = 0, size = 1, color = "red") + scale_x_continuous(breaks=sp500ByYearMean()$Group.1)
    )
    
    output$tempPlotYahoo = renderPlot({
        chartSeries(yahooData(), type = "line")
    })
    output$yahooPlot = renderPlot({
        chartSeries(yahooData(), type = "line")
    })
    output$yahooSummary = renderPrint({
        head(yahooData())
    })
    output$wikiPlot = renderPlot({
        ggplot(wikiData(), aes(date, count, group=page, color = page)) + geom_point() + 
            geom_smooth(method="lm", formula = y ~ poly(x, as.integer(length(wikiData())/100) + 2), size=1.5) + theme_bw()
    })
    output$wikiSummary = renderPrint({
        summary(wikiData())
    })
    
    output$modSummary = renderPrint({
        bestMod = getBestModel(yahooData(), wikiData(), term_count())
        print(bestMod)
    })
    
    output$text = renderText({
        paste("We predict the price of ", input$symb, " on the next trading day would be: \n", sep = "", getPred(yahooData(), wikiData(), term_count()) )
    })
    #output$result = renderPrint({
    #    getPred(yahooData(), wikiData(), term_count())
    #})
})