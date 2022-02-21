###############################
# Script to plot calculated shift as boxplot (fig 6)
# Will Vieira
# Feb, 2021
##############################



# Load data
summ_dt <- readRDS('sim-results/data/shift_dt.RDS')


# vector of names, color, practice and simulations
managName <- c('noManaged', 'Plantation', 'Harvest', 'Thinning', 'Enrichment')
sim_int <- c(2, 5, 10, 20)
mgCols = setNames(
    c( 
        'grey',
        rgb(144, 178, 67, maxColorValue = 255),
        rgb(249, 66, 37, maxColorValue = 255),
        rgb(253, 168, 48, maxColorValue = 255),
        rgb(11, 89, 105, maxColorValue = 255)
        
    ),
    managName
)
stateCols <- setNames(
    c(rgb(0, 0.54, 0.54), rgb(1, 0.647, 0)),
    c('Boreal', 'Temperate')
)
stateCols_t <- setNames(
    c(rgb(0, 0.54, 0.54, 0.55), rgb(1, 0.647, 0, 0.55)),
    c('Boreal', 'Temperate')
)



# Fig supp 3 and 4 for diff

    print('Plot figure 6')

    # rename sim and mg columns to add to boxplot
    summ_dt2 <- subset(summ_dt, sim != 'Eq1')
    summ_dt2$mg <- factor(summ_dt2$mg, levels = managName[c(5, 2, 3, 4, 1)])


    png(filename = paste0('manuscript/img/sim-result_4.png'), width = 8.5, height = 7.8, units = 'in', res = 250)
    par(mar = c(.8, 2.9, 1.2, 0.2), oma = c(.6, 0, 1.6, 0), mgp = c(1.2, 0.2, 0), tck = -.008, cex = 0.8)

    layout(
        mat = matrix(
            c(
                1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3,
                1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3,
                1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3,
                1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3,
                4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7,
                4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7,
                4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7
            ),
            nrow = 12
        )
    )

    ## Year simulation
    #####################################################
    yLim <- range(subset(summ_dt2, sim %in% paste0('T', c(250, 500, 1000), '+CC+FM'))$diff)
    if(max(yLim) < 0) yLim[which.max(yLim)] <- 0

    for(Sim in paste0('T', c(250, 500, 1000), '+CC+FM'))
    {
        boxplot(
            diff ~ state + mg,
            subset(summ_dt2, sim == Sim),
            ylim = yLim,
            xlim = c(0.8, 10.2),
            xaxt = 'n', xlab = '',
            ylab = '',
            col = rep(stateCols_t, 5),
            border = rep(stateCols, 5),
            cex.axis = 1.2
        )
        abline(v = c(2, 4, 6, 8) + 0.5, lty = 3, col = rgb(0, 0, 0, 0.2), lwd = 1.4)
        mtext(
            paste(gsub('\\D', '', Sim), 'years'),
            side = 3,
            line = 0.1
        )
        abline(h = median(subset(summ_dt, sim == 'Eq1' & RCP == 4.5)$diff), col = rgb(0, 0, 0, 0.9), lty = 5, lwd = 1)   

        if(Sim == 'T250+CC+FM') {
            legend(
                x = 6.9, y = -2.33,
                legend = c('Boreal', 'Temperate + Mixed'),
                pch = 15,
                col = stateCols,
                cex = 1.3,
                bg = 'white',
                box.col = 'white'
            )
            mtext('Simulation time:', 3, at = 1.9, line = 0.1, cex = 1.05)
        }
        text(
            x = 0.7, y = -.1,
            ifelse(Sim == 'T250+CC+FM', '(a)', ifelse(Sim == 'T500+CC+FM', '(b)', '(c)')),
            cex = 1.3
        )
    }
    mtext('State shift in annual mean temperature (°C)', side = 2, line = -1.3, outer = TRUE)
    axis(1, at = c(1, 3, 5, 7, 9) + 0.5, labels = levels(summ_dt2$mg), tick = FALSE, cex.axis = 1.3)


    ## Management intensity simulation
    #####################################################
    
    summ_dt3 <- subset(summ_dt, sim %in% paste0('T150+CC+FM_', c(2, 5, 10, 20)))
    summ_dt3$mg <- factor(summ_dt3$mg, levels = managName[c(5, 2, 3, 4)])


    # define y axis limits
    yLim <- range(subset(summ_dt3, sim %in% paste0('T150+CC+FM_', c(2, 5, 10, 20)))$diff)
    if(max(yLim) < 0) yLim[which.max(yLim)] <- 0
    abcd <- paste0('(', letters[5:8], ')')

    for(Sim in paste0('T150+CC+FM_', c(2, 5, 10, 20)))
    {
        boxplot(
            diff ~ state + mg,
            subset(summ_dt3, sim == Sim),
            ylim = yLim,
            xlim = c(0.8, 8.2),
            xaxt = 'n', xlab = '',
            ylab = '',
            col = rep(stateCols_t, 4),
            border = rep(stateCols, 5),
            cex.axis = 1.2
        )
        abline(v = c(2, 4, 6) + 0.5, lty = 3, col = rgb(0, 0, 0, 0.2), lwd = 1.4)
        mtext(
            paste0(as.numeric(gsub('.*_', '', Sim)), '%'),
            side = 3,
            line = 0.1,
            at = 5.4
        )
        abline(h = median(subset(summ_dt, sim == 'Eq1' & RCP == 4.5)$diff), col = rgb(0, 0, 0, 0.9), lty = 5, lwd = 1)    

        if(Sim == 'T150+CC+FM_2')
            mtext('Management intensity:', 3, at = 2.7, line = 0.1, cex = 1.05)

        text(
            x = 0.8, y = -.15,
            abcd[which(Sim == paste0('T150+CC+FM_', c(2, 5, 10, 20)))],
            cex = 1.3
        )
    }
    axis(1, at = c(1, 3, 5, 7) + 0.5, labels = levels(summ_dt3$mg), tick = FALSE, cex.axis = 1.3)
    dev.off()

#

