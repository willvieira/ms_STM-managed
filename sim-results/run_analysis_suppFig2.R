###############################
# Plot spatially explicit simulations
# Will Vieira
# July 3, 2019
##############################

##############################
# Steps:
  # getting data
  # calculate col proportion
  # save data
##############################

print('Running simulation analysis for supplementary figure 2')

# load simulations from the server
# system(paste("fish -c", shQuote("mammpull STMproject/simResults/output ms_STM-managed/sim-results")))

# load environment scaling parameters and functions to get equilibrum
load('num-results/sysdata.rda')
source('num-results/model_STM_managed.R')
source('num-results/model_STM.R')
source('num-results/solve_Eq.R')



# Basic info

  cellSize = 0.3
  RCP = 4.5
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025)
  reps = 1:15
  steps = c(50, 100, 200) # 250, 500, 1000 years
  mainFolder = 'sim-results/output/'
  nCol = round(800/cellSize, 0)
  nRow = round(nCol/10, 0)

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
  ci = function(x) 1.96*sd(x)/sqrt(length(x))

  # Calculate col proportion for all simulations using last time step
  count = 1
  for(stp in steps) {
    # list to store all different managements results
    listStepProp = list()

    # for each management practice, save the mean and sd of all 30 replications
    for(mg in managPractice) {
      # name of files for each replication
      fileNames = paste0(mainFolder, '/RCP_', RCP, '_mg_', mg, '/RCP_', RCP, '_mg_', mg, '_rep_', reps, '.RDS')

      # data frames to store nCol's proportion for each forest state (to be used latter for mean and IC)
      propB = propT = data.frame(matrix(rep(NA, length(reps) * nCol), ncol = reps[length(reps)]))

      # get landscape proportion
      for(rp in reps) {
        # get simulation
        sim <- readRDS(fileNames[rp])
        nCol <- sim[['nCol']]
        nRow <- sim[['nRow']]

        # landscape proportion
        land = matrix(sim[[paste0('land_T', stp)]], ncol = nCol, byrow = T)
        props = apply(land, 2, getProp, nRow = nRow)
        propB[, rp] = props["B", ]
        propT[, rp] = props["T", ] + props["M", ]

        cat('   calculating col proportion ->  ', round(count/(length(steps) * length(managPractice) * length(reps)) * 100, 0), '%\r')
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
      listStepProp[[paste0('mg_', mg)]] <- propSummary
    }

    # save specific cellSize list
    assign(paste0('listStepProp', stp), listStepProp)
  }
#

# Save outputs in data

  # create directory to save analysis output
  if(!dir.exists('sim-results/data')) dir.create('sim-results/data')

  # files
  save(list = paste0('listStepProp', steps), file = 'sim-results/data/sim_summary_supp2.rda')

#
