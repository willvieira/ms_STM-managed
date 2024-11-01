###############################
# Script to plot calculated shift as boxplot (fig 5)
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





# Figure 5

    print('Plot figure 5')

    # rename sim and mg columns to add to boxplot
    summ_dt2 <- subset(summ_dt, sim != 'Eq1')
    summ_dt2$mg <- factor(summ_dt2$mg, levels = managName[c(5, 2, 3, 4, 1)])


    # T150 + CC vs T150 + FM vs T150 + CC + FM
    png(filename = paste0('manuscript/img/sim-result_3.png'), width = 7, height = 7, units = 'in', res = 250)
    par(mfrow = c(2, 1), mar = c(1, 2.8, 1.2, 0.8), oma = c(.6, 0, .5, 0), mgp = c(1.2, 0.2, 0), tck = -.008, cex = 0.8)

    # define y axis limits`
    yLim <- range(subset(summ_dt2, sim %in% c('T150+FM', 'T150+CC+FM') & RCP %in% c(0, 4.5))$diff)
    yLim[2] <- yLim[2] + .1

    for(rcp in c(0, 4.5))
    {
        Sim <- ifelse(rcp == 0, 'T150+FM', 'T150+CC+FM')
        
        boxplot(
            diff ~ state + mg,
            subset(summ_dt2, sim == Sim & RCP == rcp),
            ylim = yLim,
            xlim = c(0.8, 10.2),
            xaxt = 'n', xlab = '',
            ylab = '',
            col = rep(stateCols_t, 5),
            border = rep(stateCols, 5)
        )
        abline(v = c(2, 4, 6, 8) + 0.5, lty = 3, col = rgb(0, 0, 0, 0.2), lwd = 1.4)
        mtext(
            ifelse(
                rcp == 0,
                'No climate change',
                paste('RCP', rcp)
            ),
            side = 3,
            line = 0,
            cex = 0.9
        )
        if(rcp == 0) {
            legend(
                x = 8, y = -2.15,
                legend = c('Boreal', 'Temperate + Mixed'),
                pch = 15,
                col = stateCols,
                cex = 1.09,
                bg = 'white',
                box.col = 'white'
            )
        }else{
            abline(
                h = median(subset(summ_dt, sim == 'Eq1' & RCP == rcp)$diff), col = rgb(0, 0, 0, 0.85),
                lty = 5, lwd = 1
            )
        }
        text(
            x = 0.7, y = 2.8,
            ifelse(rcp == 0, '(a)', '(b)'),
            cex = 1.09
        )
    }
    mtext('Range shift relative to initial mean annual temperature (°C)', side = 2, line = -1.45, outer = TRUE)
    axis(1, at = c(1, 3, 5, 7, 9) + 0.5, labels = levels(summ_dt2$mg), tick = FALSE, cex.axis = 1.2)
    dev.off()

#
