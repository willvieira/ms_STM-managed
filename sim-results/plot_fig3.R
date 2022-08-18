################################
# Plot figure 3
  # Boreal and temperate occupancy over the latitudinal gradient for different scenarios of climate change and forest management
# Will Vieira
# June 20, 2019
################################

print('Plot figure 3')

# Basic info

  cellSize = 0.3
  RCP = c(4.5, 8.5)
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025)
  reps = 1:15
  steps = 30

#



for(rcpCC in RCP)
{
  RCPs <- c(0, rcpCC)

  # Load summary data and local functions to get equilibrium of the landscape

    load(paste0('sim-results/data/sim_summary_', rcpCC, '.rda'))
    load('sim-results/data/landInfo.rda')

  #



  # plot landscape proportion

    # xlimit
    xLim <- range(env1)
    xLim[2] <- 3.5

    # lines refs
    linesRCP <- c(RCPs[1], RCPs[2], RCPs[1], RCPs[2])
    linesMg <- c(0, 0, 1, 1)

    cols <- c('#252893', '#330F0A', '#FF7182')
    Alpha = 140
    colsT <- c(
      rgb(37, 40, 148, Alpha, maxColorValue = 255),
      rgb(51, 15, 10, Alpha, maxColorValue = 255),
      rgb(255, 113, 130, Alpha, maxColorValue = 255)
    )

    # Transparence of T0 and T1 at equilibrium
    transp <- c(0.3, 0.6)

    titleLine <- 0.3 + 12.75 * 0:3
    mgTitles <- c('Plantation', 'Enrichment', 'Harvest', 'Thinning')
    legend <- c(expression(paste('T'[150], ' + CC'), paste('T'[150], ' + FM'), paste('T'[150], ' CC + FM')))

    # Create img directory in case it does not exists
    Dir <- 'manuscript/img/'
    if(!dir.exists(Dir)) dir.create(Dir)
    png(filename = paste0(Dir, 'sim-result_RCP', rcpCC, '.png'), width = 7, height = 8.5, units = 'in', res = 250)
    par(mfrow = c(4, 2), mar = c(1, 1, .6, 0), oma = c(1.2, 1.3, 1, 0), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)
    for(mg in c(1, 4, 2, 3)) { # order plantation, enrichment, harvest and thinning

      linesMg[3:4] <- mg

      # boreal
      plot(0, pch = '', xlim = xLim, ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
      axis(1, labels = ifelse(mg == 3, T, F))

      # T0
      y <- smooth.spline(x = env1, y = propSummaryT0$meanB, spar = 0)$y
      xx = c(xLim[1], env1, xLim[2]); yy = c(0, y, 0)
      polygon(xx, yy, col = rgb(0, 0.54, 0.54, transp[1]), border = NA)

      # Equilibrium
      y <- datEq[, 'EqB']
      xx <- c(xLim[1], datEq[, 'env1aUnscaled'], xLim[2]); yy = c(0, y, 0)
      polygon(xx, yy, col = rgb(0, 0.54, 0.54, transp[2]), border = NA)

      # all simulations with last time step
      for(line in 2:length(linesRCP)) {
        df = get(paste0('listRCPProp', linesRCP[line]))[[paste0('mg_', linesMg[line])]]
        polygon(c(env1, rev(env1)), c(smooth.spline(df$meanB + df$ciB, spar = 0)$y, rev(smooth.spline(df$meanB - df$ciB, spar = 0)$y)), col = colsT[line - 1], border = FALSE)
        points(smooth.spline(x = env1, y = df$meanB, spar = 0), type = 'l', col = cols[line - 1], lwd = 1.2)
      }
      if(mg == 1)legend('topright', legend = legend, lty = c(rep(1, 5), 2), col = cols, lwd = 1.3, bty = 'n', cex = 0.9)
      if(mg == 1) mtext('Boreal occupancy', 3, line = 0, cex = 0.85)

      # temperate
      plot(0, pch = '', xlim = xLim, ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n', yaxt = 'n')
      axis(1, labels = ifelse(mg == 3, T, F))
      axis(2, labels = FALSE)

      # Equilibrium
      y <- c(datEq[, 'EqT'] + datEq[, 'EqM'], rev(smooth.spline(x = env1, y = propSummaryT0$meanT, spar = 0)$y))
      xx <- c(xLim[1], datEq[, 'env1aUnscaled'], rev(env1), max(env1)); yy = c(0, y, 0)
      polygon(xx, yy, col = rgb(1, 0.647, 0, transp[2]), border = NA)

      # T0
      y <- smooth.spline(x = env1, y = propSummaryT0$meanT, spar = 0)$y
      xx = c(xLim[1], env1, max(env1)); yy = c(0, y, 0)
      polygon(xx, yy, col = rgb(1, 0.647, 0, transp[1]), border = NA)

      # all simulations with last time step
      for(line in 2:length(linesRCP)) {
        df = get(paste0('listRCPProp', linesRCP[line]))[[paste0('mg_', linesMg[line])]]

        polygon(c(env1, rev(env1)), c(smooth.spline(df$meanT + df$ciT, spar = 0)$y, rev(smooth.spline(df$meanT - df$ciT, spar = 0)$y)), col = colsT[line - 1], border = FALSE)
        points(smooth.spline(x = env1, y = df$meanT, spar = 0), type = 'l', col = cols[line - 1], lwd = 1.2)
        }
        if(mg == 1) mtext('Temperate + mixed occupancy', 3, line = 0, cex = 0.85)
        mtext(mgTitles[mg], side = 3, line = - titleLine[mg], outer = T, cex = 0.9)
      }
      mtext('State occupancy', side = 2, line = 0.3, outer = TRUE, cex = 0.92)
      mtext('Initial annual mean temperature (°C)', 1, outer = TRUE, line = 0.2, cex = 0.92)
      dev.off()

  #
}