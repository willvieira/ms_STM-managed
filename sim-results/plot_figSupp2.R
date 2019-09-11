################################
# Plot supplementary figure 2
  # Boreal and temperate occupancy over the latitudinal gradient for different scenarios of climate change and forest management
# Will Vieira
# July 3, 2019
################################

print('Plot supplementary figure 2')

# Basic info

  cellSize = 0.3
  RCP = 4.5
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025)
  reps = 1:15
  steps = c(50, 100, 200) # 250, 500, 1000 years
  sim = readRDS('sim-results/output/RCP_0_mg_0/RCP_0_mg_0_rep_1.RDS')
  nCol = sim[['nCol']]
  nRow = sim[['nRow']]
  rm(sim)

#



# Load summary data and local functions to get equilibirum of the landscape


  load('sim-results/data/sim_summary.rda')
  load('sim-results/data/sim_summary_supp2.rda')

#



# plot landscape proportion

  # colors for each line
  cols <- c(rgb(162, 255, 60, maxColorValue = 255), rgb(126, 0, 255, maxColorValue = 255))
  colsT <- c(rgb(162, 255, 60, 51, maxColorValue = 255), rgb(126, 0, 255, 51, maxColorValue = 255))

  # time step line lty
  ltys <- setNames(2:4, steps)

  # title for each management
  titleLine <- 0.3 + 12.75 * 0:3
  mgTitles <- c('Plantation', 'Enrichment', 'Harvest', 'Thinning')

  legend <- c(expression('T'[0]), 'Equilibrium', expression(paste('T'[x], ' + CC')), expression(paste('T'[x], ' + CC + FM')), 'x = 250 years', 'x = 500 years', 'x = 1000 years')


  pdf('manuscript/img/sim-result_supp2.pdf', height = 8.5)
  par(mfrow = c(4, 2), mar = c(1, 1, .6, 1), oma = c(1.2, 1.3, 1, 0), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)
  for(mg in c(1, 4, 2, 3)) { # order plantation, enrichment, harvest and thinning

    # boreal
    plot(0, pch = '', xlim = range(env1), ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
    axis(1, labels = ifelse(mg == 3, T, F))

    # Equilibrium
    points(datEq[, 'env1aUnscaled'], datEq[, 'EqB'], type = 'l', lwd = 1.2)

    # T0
    #polygon(c(env1, rev(env1)), c(propSummaryT0$meanB + propSummaryT0$ciB, rev(propSummaryT0$meanB - propSummaryT0$ciB)), col = adjustcolor('gray', alpha.f = 0.2), border = FALSE)
    lines(smooth.spline(x = env1, y = propSummaryT0$meanB, spar = 0), col = 'gray', lwd = 1.2)

    # all simulations with x time step
    for(stp in steps) {
      listStep = get(paste0('listStepProp', stp))

      # Tstep + CC
      dfCC <- listStep[['mg_0']]
      #polygon(c(env1, rev(env1)), c(smooth.spline(dfCC$meanB + dfCC$ciB, spar = 0)$y, rev(smooth.spline(dfCC$meanB - dfCC$ciB, spar = 0)$y)), col = colsT[1], border = FALSE)
      lines(smooth.spline(x = env1, y = dfCC$meanB, spar = 0), col = cols[1], lty = ltys[as.character(stp)], lwd = 1.2)

      # Tstep + CC + FM
      dfFM <- listStep[[paste0('mg_', mg)]]
      #polygon(c(env1, rev(env1)), c (smooth.spline(dfFM$meanB + dfFM$ciB, spar = 0)$y, rev(smooth.spline(dfFM$meanB - dfFM$ciB, spar = 0)$y)), col = colsT[2], border = FALSE)
      lines(smooth.spline(x = env1, y = dfFM$meanB, spar = 0), col = cols[2], lty = ltys[as.character(stp)], lwd = 1.2)
    }

    if(mg == 1)legend('topright', legend = legend, lty = c(rep(1, 4), 2:4), col = c('gray', 'black', cols[1], cols[2], rep('black', 3)), bty = 'n', cex = 0.9)
    if(mg == 1) mtext('Boreal occupancy', 3, line = 0, cex = 0.85)

    # temperate
    plot(0, pch = '', xlim = range(env1), ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
    axis(1, labels = ifelse(mg == 3, T, F))

    # Equilibrium
    points(datEq[, 'env1aUnscaled'], datEq[, 'EqT'] + datEq[, 'EqM'], type = 'l', lwd = 1.2)

    # T0
    #polygon(c(env1, rev(env1)), c(propSummaryT0$meanT + propSummaryT0$ciT, rev(propSummaryT0$meanT - propSummaryT0$ciT)), col = adjustcolor('gray', alpha.f = 0.2), border = FALSE)
    lines(smooth.spline(x = env1, y = propSummaryT0$meanT, spar = 0), col = 'gray', lwd = 1.2)

    # all simulations with x time step
    for(stp in steps) {
      listStep = get(paste0('listStepProp', stp))

      # Tstep + CC
      dfCC <- listStep[['mg_0']]
      #polygon(c(env1, rev(env1)), c(smooth.spline(dfCC$meanT + dfCC$ciT, spar = 0)$y, rev(smooth.spline(dfCC$meanT - dfCC$ciT, spar = 0)$y)), col = colsT[1], border = FALSE)
      lines(smooth.spline(x = env1, y = dfCC$meanT, spar = 0.5), col = cols[1], lty = ltys[as.character(stp)], lwd = 1.2)

      # Tstep + CC + FM
      dfFM <- listStep[[paste0('mg_', mg)]]
      #polygon(c(env1, rev(env1)), c (smooth.spline(dfFM$meanT + dfFM$ciT, spar = 0)$y, rev(smooth.spline(dfFM$meanT - dfFM$ciT, spar = 0)$y)), col = colsT[2], border = FALSE)
      lines(smooth.spline(x = env1, y = dfFM$meanT, spar = 0.5), col = cols[2], lty = ltys[as.character(stp)], lwd = 1.2)
    }

    if(mg == 1) mtext('Temperate + mixed occupancy', 3, line = 0, cex = 0.85)
    mtext(mgTitles[mg], side = 3, line = - titleLine[mg], outer = T, cex = 0.9)
  }

  mtext('State occupancy', side = 2, line = 0.3, outer = TRUE, cex = 0.92)
  mtext('Latitude (annual mean temperature)', 1, outer = TRUE, line = 0.2, cex = 0.92)
  dev.off()

#
