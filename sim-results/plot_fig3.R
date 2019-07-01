################################
# Plot figure 3
  # Boreal and temperate occupancy over the latitudinal gradient for different scenarios of climate change and forest management
# Will Vieira
# June 20, 2019
################################

print('Plot figure 3')

# Basic info

  cellSize = 0.3
  RCP = c(0, 4.5)
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025)
  reps = 1:15
  steps = 30
  nCol = round(800/cellSize, 0)
  nRow = round(nCol/10, 0)

#



# Load summary data and local functions to get equilibirum of the landscape

  load('sim-results/data/sim_summary.rda')

#



# plot landscape proportion

  # lines refs
  linesRCP <- c(RCP[1], RCP[2], RCP[1], RCP[2])
  linesMg <- c(0, 0, 1, 1)

  cols <- rainbow(length(linesRCP))
  colsT <- rainbow(length(linesRCP), alpha = 0.2)

  titleLine <- 0.3 + 12.8 * 0:3
  mgTitles <- c('Plantation', 'Enrichment', 'Harvest', 'Thinning')
  legend <- c(expression('T'[0]), expression('T'[150]), expression(paste('T'[150], ' + CC')), expression(paste('T'[150], ' + FM')), expression(paste('T'[150], ' CC + FM')), 'Equilibrium')


  pdf('manuscript/img/sim-result.pdf', height = 8.5)
  par(mfrow = c(4, 2), mar = c(1, 1, .6, 1), oma = c(1.2, 1.3, 1, 0), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)
  for(mg in c(1, 4, 2, 3)) { # order plantation, enrichment, harvest and thinning

    linesMg[3:4] <- mg
    xMax <- max(env1)

    # boreal
    plot(0, pch = '', xlim = range(env1), ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
    axis(1, labels = ifelse(mg == 3, T, F))

    # Equilibrium
    points(datEq[, 'env1aUnscaled'], datEq[, 'EqB'], type = 'l', lty = 2, col = 'darkcyan')

    # T0
    #polygon(c(env1, rev(env1)), c(propSummaryT0$meanB + propSummaryT0$ciB, rev(propSummaryT0$meanB - propSummaryT0$ciB)), col = adjustcolor('gray', alpha.f = 0.2), border = FALSE)
    lines(env1, propSummaryT0$meanB, col = 'gray')

    # all simulations with last time step
    for(line in 1:length(linesRCP)) {
      df = get(paste0('listRCPProp', linesRCP[line]))[[paste0('mg_', linesMg[line])]]
      #polygon(c(env1, rev(env1)), c(smooth.spline(df$meanB + df$ciB, spar = 0)$y, rev(smooth.spline(df$meanB - df$ciB, spar = 0)$y)), col = colsT[line], border = FALSE)
      lines(smooth.spline(x = env1, y = df$meanB, spar = 0), col = cols[line])
    }
    if(mg == 1)legend('topright', legend = legend, lty = c(rep(1, 5), 2), col = c('gray', cols, 'black'), bty = 'n', cex = 0.9)
    if(mg == 1) mtext('Boreal occupancy', 3, line = 0, cex = 0.85)

    # temperate
    plot(0, pch = '', xlim = range(env1), ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
    axis(1, labels = ifelse(mg == 3, T, F))

    # Equilibrium
    points(datEq[, 'env1aUnscaled'], datEq[, 'EqT'] + datEq[, 'EqM'], type = 'l', lty = 2, col = 'orange')

    # T0
    #polygon(c(env1, rev(env1)), c(propSummaryT0$meanT + propSummaryT0$ciT, rev(propSummaryT0$meanT - propSummaryT0$ciT)), col = adjustcolor('gray', alpha.f = 0.2), border = FALSE)
    lines(env1, propSummaryT0$meanT, col = 'gray')

    # all simulations with last time step
    for(line in 1:length(linesRCP)) {
      df = get(paste0('listRCPProp', linesRCP[line]))[[paste0('mg_', linesMg[line])]]

      #polygon(c(env1, rev(env1)), c(smooth.spline(df$meanT + df$ciT, spar = 0)$y, rev(smooth.spline(df$meanT - df$ciT, spar = 0)$y)), col = colsT[line], border = FALSE)
      lines(smooth.spline(x = env1, y = df$meanT, spar = 0), col = cols[line])
      }
      if(mg == 1) mtext('Temperate + mixed occupancy', 3, line = 0, cex = 0.85)
      mtext(mgTitles[mg], side = 3, line = - titleLine[mg], outer = T, cex = 0.9)
    }
    mtext('State occupancy', side = 2, line = 0.3, outer = TRUE, cex = 0.92)
    mtext('Latitude (annual mean temperature)', 1, outer = TRUE, line = 0.2, cex = 0.92)
    dev.off()

#
