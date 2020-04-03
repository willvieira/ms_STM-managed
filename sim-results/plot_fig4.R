###############################
# Script to plot sensitivity and exposure from the simulations
# Will Vieira
# July 30, 2019
##############################


# Get data
  # define parameters
  cellSize = 0.3
  RCP = 4.5 # TODO think if I could also use the no CC simulation
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025)
  reps = 1:15
  steps = 200
  states <- c('B', 'T', 'M', 'R')

  # get analytical data
  practices <- c('Plantation', 'Enrichment', 'Harvest', 'Thinning', 'noManaged')
  for(i in c(practices, 'noCC'))
  {
    CC <- RCP
    if(i == 'noCC') CC <- 0
    assign(paste0('dat_', which(i == practices) - 1), readRDS(file = paste0('num-results/data/fig1/dat_', i, '_', CC, '.RDS')))
  }
  # summary of simulation data
  load('sim-results/data/sim_summary_fig4.rda')
  load('sim-results/data/landInfo.rda')

#



# Get time to reach equilibrium (sensitivity) for each row of the landscape
  getEq <- function(x, steps = steps, limit = 6e-4) {
    if(!any(which(x < limit))) { # if none is smaller than limit
      eq = steps
    }else if(!any(which(x > limit))) { # if none is larger than limit
      eq = 1
    }else{
      # get only the part of vector that comes after the higher value of the vector
      # It will avoid small eq in a gaussian curve for instance
      maxX <- which.max(x)
      x <- x[maxX:steps]

      if(!any(which(x < limit))) { # if none is larger than limit
        eq = steps
        run = FALSE
      }else{
        pos <- which(x < limit)
        minPos <- min(pos)
        run = TRUE
        if(minPos > (steps - 10)) { eq = minPos; run = FALSE }
        if(length(pos) < 10) { eq = steps; run = FALSE }
      }

      if(run == TRUE) {
        keep = TRUE
        startPos = 1
        while(keep == TRUE) {
          test <- pos[startPos:(startPos + 9)] == pos[startPos]:(pos[startPos] + 9)
          if(all(test, na.rm = T) == TRUE) {
            keep = FALSE
          }else{
            if(any(is.na(test))) {
              keep = FALSE
            }else{
              startPos = startPos + sum(test)
              if(startPos >= length(pos)) keep = FALSE
            }
          }
        }
        eq <- pos[startPos] + (maxX - 1)
      }
    }
    return(eq)
  }
#

# management colors (full and transparent colours)

  Alpha = 255
  mgCols = setNames(c(rgb(144, 178, 67, Alpha, maxColorValue = 255),
             rgb(249, 66, 37, Alpha, maxColorValue = 255),
             rgb(253, 168, 48, Alpha, maxColorValue = 255),
             rgb(11, 89, 105, Alpha, maxColorValue = 255),
             rgb(0, 0, 0, Alpha, maxColorValue = 255)), c(1:4, 0))
  Alpha = 60
  mgColsT = setNames(c(rgb(144, 178, 67, Alpha, maxColorValue = 255),
             rgb(249, 66, 37, Alpha, maxColorValue = 255),
             rgb(253, 168, 48, Alpha, maxColorValue = 255),
             rgb(11, 89, 105, Alpha, maxColorValue = 255),
             rgb(0, 0, 0, Alpha, maxColorValue = 255)), c(1:4, 0)
  )

#



  # plot
  print('Plot figure 4')

  # Create img directory in case it does not exists
  Dir <- 'manuscript/img/'
  if(!dir.exists(Dir)) dir.create(Dir)
  png(filename = paste0(Dir, 'sim-result_2.png'), width = 6.4, height = 4.8, units = 'in', res = 250)
  par(mfcol = c(2, 2), mar = c(1, 2, 1, 1), oma = c(1.2, 0.5, 0.6, 0), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)

  # Plot 1 - Exposure (analytical and simulation plots)

  # analytical
  plot(env1unscaled, 1:length(env1unscaled), pch = '', ylim = c(-0.01, 1.1), xlab = '', ylab = '', xaxt = 'n')
  axis(1, labels = F)
  for(mg in as.character(c(1:4, 0)))
  {
    points(get(paste0('dat_', mg))[, c('env1aUnscaled', 'Exposure')], type = 'l', lwd = 1.2, col = mgCols[mg])
  }
  mtext("Exposure", 2, line = 1.2, cex = 0.92)

  # simulation
  plot(env1unscaled, smooth.spline(eDist_mg1[, 1], spar = 0.4)$y, pch = '', xlab = '', ylab = '', lwd = 1.2, col = mgCols[1], ylim = c(-0.01, 1.1))
  for(mg in as.character(c(1:4, 0))) {
    polygon(c(env1unscaled, rev(env1unscaled)), c(smooth.spline(get(paste0('eDist_mg', mg))[, 1] + get(paste0('eDist_mg', mg))[, 2], spar = 0.4)$y, rev(smooth.spline(get(paste0('eDist_mg', mg))[, 1] - get(paste0('eDist_mg', mg))[, 2], spar = 0.4)$y)), col = mgColsT[mg], border = FALSE)
    lines(env1unscaled, smooth.spline(get(paste0('eDist_mg', mg))[, 1], spar = 0.4)$y, lwd = 1.2, col = mgCols[mg])
  }
  mtext("Exposure", 2, line = 1.2, cex = 0.92)

  # Plot 2 - Sensitivity

  # analytical
  # get ylim max to scale sensitivity
  yMax <- numeric(length(managPractice))
  for(mg in c(1:4, 0)) yMax[mg + 1] <- max(get(paste0('dat_', mg))[, 'Sensitivity'])
  yMax <- max(yMax)
  plot(env1unscaled, 1:length(env1unscaled), pch = '', ylim = c(-0.01, 1.03), xlab = '', ylab = '', xaxt = 'n')
  axis(1, labels = F)
  for(mg in as.character(c(1:4, 0)))
  {
    lines(get(paste0('dat_', mg))[, 'env1aUnscaled'], get(paste0('dat_', mg))[, 'Sensitivity']/yMax, lwd = 1.2, col = mgCols[mg])
  }
  mtext("Sensitivity (scaled)", 2, line = 1.2, cex = 0.92)

  # simulation
  limit = 15e-4
  plot(env1unscaled, 1:length(env1unscaled), pch = '', ylim = c(-0.01, 1.03), xlab = '
  ', ylab = '', col = mgCols[5])
  for(mg in as.character(c(1:4, 0))) {
    Mean <- apply(get(paste0('tempDiff_mg', mg))[,,1], 1, getEq, steps = steps, limit = limit)
    ciUpperMatrix <- get(paste0('tempDiff_mg', mg))[,,1] + get(paste0('tempDiff_mg', mg))[,,2]
    ciLowerMatrix <- get(paste0('tempDiff_mg', mg))[,,1] - get(paste0('tempDiff_mg', mg))[,,2]
    CIupper <- apply(ciUpperMatrix, 1, getEq, steps = steps, limit = limit)
    CIlower <- apply(ciLowerMatrix, 1, getEq, steps = steps, limit = limit)

    polygon(c(env1unscaled, rev(env1unscaled)), c(smooth.spline(CIupper, spar = 0.4)$y/steps, rev(smooth.spline(CIlower, spar = 0.4)$y/steps)), col = mgColsT[mg], border = FALSE)
    lines(env1unscaled, smooth.spline(Mean, spar = 0.4)$y/steps, col = mgCols[mg])
  }
  mtext("Sensitivity (scaled)", 2, line = 1.2, cex = 0.92)
  legend('topright', legend = c('Plantation', 'Enrichment', 'Harvest', 'Thinning', 'noManaged'), lty = 1, col = mgCols[as.character(c(1, 4, 2, 3, 0))], bty = 'n', cex = 1)
  mtext("Latitude (annual mean temperature)", 1, line = 0.1, cex = 0.92, outer = TRUE)
  mtext("Analytical model", 3, line = -0.85, cex = 0.92, outer = TRUE)
  mtext("Spatially explicit model", 3, line = -14.85, cex = 0.92, outer = TRUE)

  dev.off()
#
