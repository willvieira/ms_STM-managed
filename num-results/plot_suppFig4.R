################################
# Parameter values for the boreal-mixed gradient
# Will Vieira
# March 24, 2020
################################


## Setup

    # Get functions and paramaters
    source('num-results/model_STM_managed.R')
    load('num-results/sysdata.rda')

    # Get data for ploting state distribution in equilibrium with climate
    dat_noCC <- readRDS('num-results/data/fig1/dat_noCC_0.RDS')
    dat_noManaged <- readRDS('num-results/data/fig1/dat_noManaged_4.5.RDS')

    # Latitudinal gradient of (scaled) temperature
    env1a <- seq(-2.5, 0.35, 0.01)

    # Unscale environment gradient (temperature)
    tempSc0 <- env1a
    tempUn0 <- tempSc0 * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']

    # add climate change (RCP 4.5 and 8.5)
    tempUn1 <- tempUn0 + 1.8
    tempUn2 <- tempUn0 + 3.7
    
    # scale warming temperature
    env1CC <- (tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']
    env2CC <- (tempUn2 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']

    # Get parameters for each temp value
    pars <-  sapply(env1a, function(x) get_pars(ENV1 = x, ENV2 = 0, params = params, int = 5))
    pars1CC <- sapply(env1CC, function(x) get_pars(ENV1 = x, ENV2 = 0, params = params, int = 5))
    pars2CC <- sapply(env2CC, function(x) get_pars(ENV1 = x, ENV2 = 0, params = params, int = 5))

##



## plot
    print("Plot supplementary figure 4")
    
    # plot colours
    stateCols <- c("darkcyan", "orange", "palegreen3", "black")
    parsColours <- col2rgb(RColorBrewer::brewer.pal(n = nrow(pars), name = "Paired"), alpha = TRUE)
    parsColours[4, ] <- 1 * 255
    parsColours <- parsColours/255
    colsPars <- rgb(parsColours[1, ], parsColours[2, ], parsColours[3, ], parsColours[4, ])

    # legend math symbols
    legendPars <- c(expression(alpha['B'],
                            alpha['T'],
                            beta['B'],
                            beta['T'],
                            theta,
                            theta['T'],
                            epsilon['B'],
                            epsilon['T'],
                            epsilon['M']
                            ))

     Dir <- 'manuscript/img/'
    if(!dir.exists(Dir)) dir.create(Dir)
    png(filename = paste0(Dir, 'num-result_supp2.png'), width = 6.7, height = 5, units = 'in', res = 250)
    
    par(mfcol = c(2, 2), mar = c(1, 2.5, .5, 0.8), oma = c(1.5, 0, 0.5, 0), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 0.8)

    plot(dat_noManaged[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1.08), col = stateCols[1], lwd = 1.2)
    points(dat_noManaged$env1aUnscaled, dat_noManaged$EqM + dat_noManaged$EqT, type = 'l', col = stateCols[2], lwd = 1.2)
    points(dat_noCC[, c('env1aUnscaled', 'EqB')], type = 'l', xlab = '', ylab = 'State proportion', ylim = c(0, 1), col = stateCols[1], lty = 2, lwd = 1.2)
    points(dat_noCC$env1aUnscaled, dat_noCC$EqM + dat_noCC$EqT, type = 'l', col = stateCols[2], lty = 2, lwd = 1.2)
    legend(1.5, 0.94, legend = c('Boreal', 'Mixed +\nTemperate'), lty = 1, col = c(stateCols[1], stateCols[2]), bty = 'n', cex = 1, lwd = 1.2)
    legend(1.5, 0.58, legend = c(expression(paste('T'[0], ' equilibrium')), expression(paste('T'[1], ' equilibrium'))), lty = c(2, 1), col = 1, bty = 'n', cex = 1, lwd = 1.2)
    legend(-3.4, 1.14, legend = '(a)', bty = 'n')

    plot(tempUn0, pars[1, ], pch = '', ylim = c(0, 1.08), xlab = '', ylab = 'Parameter before CC')
    for(i in 1:nrow(pars)) points(tempUn0, pars[i, ], type = 'l', col = colsPars[i])
    legend(-3.4, 1.14, legend = '(b)', bty = 'n')
    
    plot(tempUn0, pars[1, ], pch = '', ylim = c(0, 1.08), xlab = '', ylab = 'Parameter after CC (RCP 4.5)')
    for(i in 1:nrow(pars1CC)) points(tempUn0, pars1CC[i, ], type = 'l', col = colsPars[i])
    legend(-3.4, 1.14, legend = '(c)', bty = 'n')

    plot(tempUn0, pars[1, ], pch = '', ylim = c(0, 1.08), xlab = '', ylab = 'Parameter after CC (RCP 8.5)')
    for(i in 1:nrow(pars2CC)) points(tempUn0, pars2CC[i, ], type = 'l', col = colsPars[i])
    legend('topright', legend = legendPars, lty = 1, col = colsPars, bty = 'n', cex = 1.2)
    legend(-3.4, 1.14, legend = '(d)', bty = 'n')

    mtext("Initial mean annual temperature (°C)", 1, line = 0.2, cex = 0.92, outer = TRUE)
    dev.off()

