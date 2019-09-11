###############################
# Script to calculate sensitivity and exposure from the simulations
# Will Vieira
# July 30, 2019
##############################

##############################
# Steps:
  # get data (all simulations)
  # For the sensitivity figure
    # Organize stateOccup for each time and repetition in an array
    # calculate mean and CI transient dynamic for the whole latitude
  # For the exposure figure
    # Calculate the mean and CI euclidean distance between last and first state proportion
  # Save calculated data as RDS
##############################

print('Running simulation analysis for figure 4')

# load simulations from the server
# system(paste("fish -c", shQuote("mammpull STMproject/simResults/output ms_STM-managed/sim-results")))

# getting data
  print('[1/4] Getting simulation data')

  cellSize = 0.3
  RCP = 4.5 # TODO think if I could also use the no CC simulation
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025)
  reps = 1:15
  steps = 200
  states <- c('B', 'T', 'M', 'R')
  sim = readRDS('sim-results/output/RCP_0_mg_0/RCP_0_mg_0_rep_1.RDS')
  nCol = sim[['nCol']]
  rm(sim)
  
  # load environment scaling parameters
  load('num-results/sysdata.rda')

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

  # clean up
  rm(list = c('folderName', 'fileName', 'mainFolder'))
#



# Get env1 unscaled
  env1unscaled <- get('RCP_4.5_mg_0_rep_1')[['env1']] * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']

#

# Organize stateOccup for each time and repetition in an array

  print('[2/4] Organize state occupancy in lists')

  # Create length(managPractice) lists containing 4 (states) arrays with dimension steps x landRow x reps
  count = 1
  for(mg in managPractice)
  {

    arB = arT = arM = arR = array(0, dim = c(nCol, steps + 1, length(reps)))
    for(rp in reps)
    {
      sim <- get(paste0('RCP_', RCP, '_mg_', mg, '_rep_', rp))[['stateOccup']]

      # get a matrix for each state containing temporal variation for each
      # col of the landcape
      for(state in states)
      {
        assign(paste0('mt', state), sapply(sim, function(x) x[state, ]))
      }

      arB[,,rp] <- mtB
      arT[,,rp] <- mtT
      arM[,,rp] <- mtM
      arR[,,rp] <- mtR

      cat('   creating output lists ', round(count/(length(managPractice) * length(reps)) * 100, 0), '%\r')
      count <- count + 1
    }

    assign(paste0('list_mg', mg), list(arB = arB, arT = arT, arM = arM, arR = arR))
  }

  # clean up
  rm(list = c(paste0('ar', states), paste0('mt', states), 'sim'))
#



# calculate mean and CI transient dynamic for the whole latitude

  print('[3/4] Calculate mean and CI transient dynamic for each landscape latitude')

  count = 1
  for(mg in managPractice)
  {

    listMg <- get(paste0('list_mg', mg))
    dims <- dim(listMg[[1]])

    # get array result with mean and CI
    for(state in states)
    {
      # dataframes for mean and CI
      mMean = mCI = matrix(0, nrow = dims[1], ncol = dims[2])

      # mean
      for(i in reps) mMean <- mMean + listMg[[paste0('ar', state)]][,, i]
      mMean <- mMean/length(reps)

      # CI
      ## first get sd()
      for(i in 1:dims[1]) {
        for(j in 1:dims[2]) {
          mCI[i, j] <- sd(listMg[[paste0('ar', state)]][i, j, ])
        }
      }
      mCI <- mCI * 1.96/sqrt(length(reps))

      # create array with mean and CI for the state
      assign(paste0('ar', state), simplify2array(list(mMean, mCI)))

      cat('   creating summary lists  ', round(count/(length(managPractice) * length(states)) * 100, 0), '%\r')
      count <- count + 1
    }

    # create list for each managPractice
    assign(paste0('summaryList_mg', mg), list(arB = arB, arT = arT, arM = arM, arR = arR))
  }


  # clean up
  rm(list = c('listMg', 'mMean', 'mCI', paste0('ar', states)))


  # Sum the mean and CI of all states
  print('[3/4] Calculate mean and CI transient dynamic for each landscape latitude')
  for(mg in managPractice)
  {
    cat('Management practice ', mg + 1, ' of ', length(managPractice), '\n')
    sim <- get(paste0('summaryList_mg', mg))

    datM = datCI = matrix(0, nrow = dim(sim[[1]])[1], ncol = dim(sim[[1]])[2] - 1)

    spar = 0.8
    for(i in 1:dim(sim[[1]])[1])
    {
      datM[i, ] <- abs(diff(smooth.spline(sim[['arB']][,,1][i, ], spar = spar)$y)) +
                   abs(diff(smooth.spline(sim[['arT']][,,1][i, ], spar = spar)$y)) +
                   abs(diff(smooth.spline(sim[['arM']][,,1][i, ], spar = spar)$y)) +
                   abs(diff(smooth.spline(sim[['arR']][,,1][i, ], spar = spar)$y))

      datCI[i, ] <- abs(diff(smooth.spline(sim[['arB']][,,2][i, ], spar = spar)$y)) +
                    abs(diff(smooth.spline(sim[['arT']][,,2][i, ], spar = spar)$y)) +
                    abs(diff(smooth.spline(sim[['arM']][,,2][i, ], spar = spar)$y)) +
                    abs(diff(smooth.spline(sim[['arR']][,,2][i, ], spar = spar)$y))

      cat('      calculating temporal difference    ', round(i/dim(sim[[1]])[1] * 100, 0), '% \r')
    }
    cat('      calculating temporal difference    ', round(i/dim(sim[[1]])[1] * 100, 0), '% \n')

    assign(paste0('tempDiff_mg', mg), simplify2array(list(datM, datCI)))
  }

#



# Calculate the mean and CI euclidean distance between last and first state proportion

  print('[4/4] Calculate Exposure for each landscape latitude')

  # Confidence interval function
  ci = function(x) 1.96 * sd(x)/sqrt(length(x))

  # Create length(managPractice) lists containing a data frame with Dist values
  # (nrow) for each rep (ncol)
  count = 1
  for(mg in managPractice)
  {

    df <- data.frame(matrix(rep(NA, dims[1] * length(reps)), nrow = dims[1]))
    for(rp in reps)
    {
      sim <- get(paste0('RCP_', RCP, '_mg_', mg, '_rep_', rp))[['stateOccup']]

      # calculate euclidean dist between first [1] and last [steps + 1] state proprotion
      for(latitude in 1:dims[1])
        df[latitude, rp] <- dist(rbind(sim[[1]][, latitude], sim[[(steps + 1)]][, latitude]))

      cat('   creating output data frames ', round(count/(length(managPractice) * length(reps)) * 100, 0), '%\r')
      count <- count + 1
    }

    # Calculate mean and CI (save in a data frame wiht mean and CI columns)
    dfSummary <- data.frame(distMean = apply(df, 1, mean))
    dfSummary$distCI <- apply(df, 1, ci)

    assign(paste0('eDist_mg', mg), dfSummary)
  }

#



# Save calculated data as RDS
  obj <- c('env1unscaled', paste0('tempDiff_mg', managPractice), paste0('eDist_mg', managPractice))
  save(list = obj, file = 'sim-results/data/sim_summary_fig4.rda')

#
