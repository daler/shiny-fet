library(shiny)
library(vcd)
library(Cairo)
options(shiny.usecairo=TRUE)

get.table <- function(input){
    r1c1 <- input$interesting
    r1c2 <- input$genes_with_peak - r1c1
    r2c1 <- input$upregulated - r1c1
    r2c2 <- input$genes - r1c1 - r1c2 - r2c1
    m <- matrix(
        c(
          r1c1, r1c2,
          r2c1, r2c2),
        nrow=2,
        dimnames=list(
            peak=c('peak in promoter', 'no peak'),
            genes=c('upregulated', 'not upregulated')
            )
        )
}


fet <- function(X){
    m <- sum(X[, 1L])  # first column sum
    n <- sum(X[, 2L])  # second column sum
    k <- sum(X[1L, ])  # first row sum
    x <- X[1L, 1L]     # value of upper left cell
    lo <- max(0L, k - n)
    hi <- min(k, m)
    support <- lo:hi
    logdc <- dhyper(support, m, n, k, log = TRUE)
    dnhyper <- function(ncp) {
        d <- logdc + log(ncp) * support
        d <- exp(d - max(d))
        d/sum(d)
    }
    oddsratio <- (X[1,1]/X[1,2])/(X[2,1]/X[2,2])
    d <- dnhyper(1)
    PVAL <- sum(d[d <= d[x - lo + 1]])
    return(list(pval=PVAL, d=d, oddsratio=oddsratio, x=x))
}

formatDecimal <- function(x, k) format(round(x, k), trim=T, nsmall=k)


# Define server logic required to draw a histogram
shinyServer(
    function(input, output) {
        output$distPlot <- renderPlot({
            X <- get.table(input)
            res <- fet(X)
            LIM <- input$xmax
            d <- res[['d']]
            x <- res[['x']]
            plot(d[1:LIM], type='l', lwd=2, xlab='Number of upregulated genes with peak', ylab='density')
            lines(d[d<=d[x+1]], col='red', lwd=2)
            abline(v=x, col='blue', lwd=2)
        })
        output$mosaicplot <- renderPlot({
            X <- get.table(input)
            mosaic(X, main="")
        })
        output$counts <- renderTable({
            X <- get.table(input)
            y <- as.data.frame(addmargins(X))
            y[, c(1, 2,3)] <- apply(y[, c(1,2,3)], 1, as.integer)
            y
        }, caption='2x2 table of counts, with marginal sums',
           caption.placement='bottom',
           caption.width=NULL
        )

        output$rowperc <- renderTable({
            X <- addmargins(get.table(input))
            X <- X / X[,3] * 100
            X[1:2,]
        }, caption='Fraction of genes that are upregulated or not',
           caption.placement='bottom',
           caption.width=NULL
        )
        output$colperc <- renderTable({
            X <- addmargins(t(get.table(input)))
            X <- X / X[,3] * 100
            X[1:2,]
            t(X)[,1:2]
        }, caption='Fraction of genes that have a peak or not',
           caption.placement='bottom',
           caption.width=NULL
        )
        output$pval <- renderText({
            X <- get.table(input)
            res <- fet(X)
            paste('pval:', signif(res[['pval']], 4))
        })
        output$or <- renderText({
            X <- get.table(input)
            res <- fet(X)
            paste('odds ratio:', signif(res[['oddsratio']], 4))
        })
        output$results <- renderText({
            X <- get.table(input)
            res <- fet(X)
            or <- res[['oddsratio']]
            pval <- res[['pval']]
            if (or < 1) {direction <- 'depleted'} else {direction <- 'enriched'}
            if (pval > 0.05){ direction <- 'n.s'}
            direction
        })
})
