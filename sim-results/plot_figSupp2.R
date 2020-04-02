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

#



# Load summary data and local functions to get equilibrium of the landscape

  load('sim-results/data/sim_summary.rda')
  load('sim-results/data/sim_summary_supp2.rda')
  load('sim-results/data/landInfo.rda')

#



# plot landscape proportion

  # xlimit
  xLim <- range(env1)
  xLim[2] <- 3.75

  # colors for each line  
  cols <- c('#252893', '#FF7182')

  # Transparence of T0 and T1 at equilibrium
  transp <- c(0.3, 0.6)
  
  # time step line lty
  ltys <- setNames(2:4, steps)

  # title for each management
  titleLine <- 0.3 + 12.75 * 0:3
  mgTitles <- c('Plantation', 'Enrichment', 'Harvest', 'Thinning')

  legend <- c(expression(paste('T'[x], ' + CC'), paste('T'[x], ' + CC + FM')), 'x = 250 years', 'x = 500 years', 'x = 1000 years')

  # Create img directory in case it does not exists
  Dir <- 'manuscript/img/'
  if(!dir.exists(Dir)) dir.create(Dir)
  png(filename = paste0(Dir, 'sim-result_supp2.png'), width = 7, height = 8.5, units = 'in', res = 250)
  par(mfrow = c(4, 2), mar = c(1, 1, .6, 1), oma = c(1.2, 1.3, 1, 0), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)
  for(mg in c(1, 4, 2, 3)) { # order plantation, enrichment, harvest and thinning

    # boreal
    plot(0, pch = '', xlim = range(env1), ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
    axis(1, labels = ifelse(mg == 3, T, F))

    # Equilibrium
    y <- datEq[, 'EqB']
    xx <- c(xLim[1], datEq[, 'env1aUnscaled'], xLim[2]); yy = c(0, y, 0)
    polygon(xx, yy, col = rgb(0, 0.54, 0.54, transp[2]), border = NA)

    # T0
    y <- smooth.spline(x = env1, y = propSummaryT0$meanB, spar = 0)$y
    xx = c(xLim[1], env1, xLim[2]); yy = c(0, y, 0)
    polygon(xx, yy, col = rgb(0, 0.54, 0.54, transp[1]), border = NA)

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

    if(mg == 1)legend('topright', legend = legend, lty = c(rep(1, 2), 2:4), col = c(cols, rep('black', 3)), lwd = 1.3, bty = 'n', cex = 0.9)
    if(mg == 1) mtext('Boreal occupancy', 3, line = 0, cex = 0.85)

    # temperate
    plot(0, pch = '', xlim = xLim, ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
    axis(1, labels = ifelse(mg == 3, T, F))

    # Equilibrium
    y <- c(datEq[, 'EqT'] + datEq[, 'EqM'], rev(smooth.spline(x = env1, y = propSummaryT0$meanT, spar = 0)$y))
    xx <- c(xLim[1], datEq[, 'env1aUnscaled'], rev(env1), max(env1)); yy = c(0, y, 0)
    polygon(xx, yy, col = rgb(1, 0.647, 0, transp[2]), border = NA)

    # T0
    y <- smooth.spline(x = env1, y = propSummaryT0$meanT, spar = 0)$y
    xx = c(xLim[1], env1, max(env1)); yy = c(0, y, 0)
    polygon(xx, yy, col = rgb(1, 0.647, 0, transp[1]), border = NA)

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
