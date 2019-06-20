###############################
# Plot spatially explicit simulations
# Will Vieira
# May 16, 2019
##############################

##############################
# Steps:
  # getting data
  # calculate col proportion
  # plot landscape proportion
##############################

print('Running simulation analysis for figure 3')

# load simulations from the server
# system(paste("fish -c", shQuote("mammpull STMproject/simResults/output ms_STM-managed/sim-results")))

# load environment scaling parameters
load('num-results/sysdata.rda')

# getting data (it takes about 3 minutes to load all 300 simulations)
  cellSize = 0.3
  RCP = c(0, 4.5)
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025)
  reps = 1:30
  steps = 200


  mainFolder = 'sim-results/output/'
  count = 1
  for(cc in RCP) {
    for(mg in managPractice) {
      folderName = paste0('RCP_', cc, '_mg_', mg)
      for(rp in reps) {
        fileName = paste0('RCP_', cc, '_mg_', mg, '_rep_', rp, '.RDS')
        assign(sub('\\.RDS$', '', fileName), readRDS(paste0(mainFolder, folderName, '/', fileName)))
        cat('   loading ouput files ', round((count/(length(RCP) * length(managPractice) * length(reps))) * 100, 0), '%\r')
        count <- count + 1
      }
    }
  }
#

# calculate col proportion, range limit and migration rate

  # function to get summary for each col
  getProp <- function(x, nRow) {
     B <- sum(x == 1)/nRow
     T <- sum(x == 2)/nRow
     M <- sum(x == 3)/nRow
     R <- 1 - sum(B, T, M)
     return(setNames(c(B, T, M, R), c('B', 'T', 'M', 'R')))
  }

  # Confidence interval function
  ci = function(x) qt(0.975, df=length(x)-1)*sd(x)/sqrt(length(x))


  # calculate col proportion for T0 using the initial landscape
  # Using any simulation because the 30 different initial landscape are the same for all simulations
  fileNames <- paste0('RCP_0_mg_0_rep_', reps)

  # data frames to store nCol's proportion for each forest state (to be used latter for mean and IC)
  propB = propT = data.frame(matrix(rep(NA, length(reps) * (get(fileNames[[1]])[['nCol']])), ncol = reps[length(reps)]))

  for(rp in reps) {
    # get simulation
    sim <- get(fileNames[rp])
    nCol <- sim[['nCol']]
    nRow <- sim[['nRow']]

    # landscape proportion
    land = matrix(sim[[paste0('land_T0')]], ncol = nCol, byrow = T)
    props = apply(land, 2, getProp, nRow = nRow)
    propB[, rp] = props["B", ]
    propT[, rp] = props["T", ] + props["M", ]

    cat('   calculating col proportion for T0 ->  ', round(rp/length(reps) * 100, 0), '%\r')
  }

  # calculate mean and sd for landscape proportion
  propSummaryT0 <- data.frame(meanB = apply(propB, 1, mean))
  propSummaryT0$ciB <- apply(propB, 1, ci)
  propSummaryT0$meanT <- apply(propT, 1, mean)
  propSummaryT0$ciT <- apply(propT, 1, ci)

  # get env1 and unscale to be the x axis
  env1 <- get(fileNames[1])[['env1']] * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']
  # remove border
  env1 <- env1[-c(1, length(env1))]
  # remove border
  propSummaryT0 = propSummaryT0[c(-1, -nrow(propSummaryT0)), ]

  # Calculate col proportion for all simulations using last time step
  count = 1
  for(cc in RCP) {
    # list to store all different managements results
    listRCPProp = list()

    # for each management practice, save the mean and sd of all 30 replications
    for(mg in managPractice) {
      # name of files for each replication
      fileNames = paste0('RCP_', cc, '_mg_', mg, '_rep_', reps)

      # data frames to store nCol's proportion for each forest state (to be used latter for mean and IC)
      propB = propT = data.frame(matrix(rep(NA, length(reps) * (get(fileNames[[1]])[['nCol']])), ncol = reps[length(reps)]))

      # get landscape proportion
      for(rp in reps) {
        # get simulation
        sim <- get(fileNames[rp])
        nCol <- sim[['nCol']]
        nRow <- sim[['nRow']]

        # landscape proportion
        land = matrix(sim[[paste0('land_T', steps)]], ncol = nCol, byrow = T)
        props = apply(land, 2, getProp, nRow = nRow)
        propB[, rp] = props["B", ]
        propT[, rp] = props["T", ] + props["M", ]

        cat('   calculating col proportion for T1 ->  ', round(count/(length(RCP) * length(managPractice) * length(reps)) * 100, 0), '%\r')
        count <- count + 1
      }

      # calculate mean and sd for landscape proportion
      propSummary <- data.frame(meanB = apply(propB, 1, mean))
      propSummary$ciB <- apply(propB, 1, ci)
      propSummary$meanT <- apply(propT, 1, mean)
      propSummary$ciT <- apply(propT, 1, ci)

      # remove border
      propSummary = propSummary[c(-1, -nrow(propSummary)), ]

      # append in the list
      listRCPProp[[paste0('mg_', mg)]] <- propSummary
    }

    # save specific cellSize list
    assign(paste0('listRCPProp', cc), listRCPProp)
  }
#



# plot landscape proportion
  # lines refs
  linesRCP <- c(RCP[1], RCP[2], RCP[1], RCP[2])
  linesMg <- c(0, 0, 1, 1)

  cols <- rainbow(length(linesRCP))
  colsT <- rainbow(length(linesRCP), alpha = 0.2)

  titleLine <- 0.3 + 12.8 * 0:3
  mgTitles <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment')
  legend <- c(expression('T'[0]), expression('T'[1]), expression(paste('T'[1], ' + CC')), expression(paste('T'[1], ' + FM')), expression(paste('T'[1], ' CC + FM')))


  pdf('manuscript/img/sim-result.pdf', height = 8.5)
  par(mfrow = c(4, 2), mar = c(1, 1, .6, 1), oma = c(1.2, 1.3, 1, 0), mgp = c(1.2, 0.2, 0), tck = -.01, cex = 0.8)
  for(mg in 1:4) {

    linesMg[3:4] <- mg
    xMax <- max(env1)

    # boreal
    plot(0, pch = '', xlim = range(env1), ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
    axis(1, labels = ifelse(mg == 4, T, F))

    # T0
    polygon(c(env1, rev(env1)), c(propSummaryT0$meanB + propSummaryT0$ciB, rev(propSummaryT0$meanB - propSummaryT0$ciB)), col = adjustcolor('gray', alpha.f = 0.2), border = FALSE)
    lines(env1, propSummaryT0$meanB, col = 'gray')

    # all simulations with last time step
    for(line in 1:length(linesRCP)) {
      df = get(paste0('listRCPProp', linesRCP[line]))[[paste0('mg_', linesMg[line])]]
      polygon(c(env1, rev(env1)), c(smooth.spline(df$meanB + df$ciB, spar = 0)$y, rev(smooth.spline(df$meanB - df$ciB, spar = 0)$y)), col = colsT[line], border = FALSE)
      lines(smooth.spline(x = env1, y = df$meanB, spar = 0), col = cols[line])
    }
    if(mg == 1)legend('topright', legend = legend, lty = 1, col = c('gray', cols), bty = 'n', cex = 0.9)
    if(mg == 1) mtext('Boreal occupancy', 3, line = 0, cex = 0.85)

    # temperate
    plot(0, pch = '', xlim = range(env1), ylim = c(0, 1), xlab = '', ylab = '', xaxt = 'n')
    axis(1, labels = ifelse(mg == 4, T, F))
    # T0
    polygon(c(env1, rev(env1)), c(propSummaryT0$meanT + propSummaryT0$ciT, rev(propSummaryT0$meanT - propSummaryT0$ciT)), col = adjustcolor('gray', alpha.f = 0.2), border = FALSE)
    lines(env1, propSummaryT0$meanT, col = 'gray')

    # all simulations with last time step
    for(line in 1:length(linesRCP)) {
      df = get(paste0('listRCPProp', linesRCP[line]))[[paste0('mg_', linesMg[line])]]

      polygon(c(env1, rev(env1)), c(smooth.spline(df$meanT + df$ciT, spar = 0)$y, rev(smooth.spline(df$meanT - df$ciT, spar = 0)$y)), col = colsT[line], border = FALSE)
      lines(smooth.spline(x = env1, y = df$meanT, spar = 0), col = cols[line])
      }
      if(mg == 1) mtext('Temperate + mixed occupancy', 3, line = 0, cex = 0.85)
      mtext(mgTitles[mg], side = 3, line = - titleLine[mg], outer = T, cex = 0.9)
    }
    mtext('State occupancy', side = 2, line = 0.3, outer = TRUE, cex = 0.92)
    mtext('Latitude (annual mean temperature)', 1, outer = TRUE, line = 0.2, cex = 0.92)
    dev.off()

#
