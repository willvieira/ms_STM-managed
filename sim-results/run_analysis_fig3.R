###############################
# Plot spatially explicit simulations
# Will Vieira
# May 16, 2019
##############################

##############################
# Steps:
  # getting data
  # calculate col proportion
  # save data
##############################

print('Running simulation analysis for figure 3')

# load simulations from the server
# system(paste("fish -c", shQuote("mammpull STMproject/simResults/output ms_STM-managed/sim-results")))

# load environment scaling parameters and functions to get equilibrum
load('num-results/sysdata.rda')
source('num-results/model_STM_managed.R')
source('num-results/model_STM.R')
source('num-results/solve_Eq.R')



# Basic info

  cellSize = 0.3
  RCP = c(4.5, 8.5)
  managPractice <- 0:4
  managInt <- c(0.0025, 0.01, 0.0025, 0.0025)
  reps = 1:15
  steps = 30 # 150 years
  mainFolder = 'sim-results/output/'
  sim = readRDS('sim-results/output/RCP_0_mg_0/RCP_0_mg_0_rep_1.RDS')
  nCol = sim[['nCol']]
  nRow = sim[['nRow']]
  rm(sim)

#


for(rcpCC in RCP)
{
  RCPs <- c(0, rcpCC)
  
  # Get equilirium for the landscape after climate change

    print('[1/3] Calculate equilibria of the landscape after warming temperature')

    # create env1 before (a) and after (b) climate change
    env1a <- seq(-2.5, 0.35, length.out = nCol)

    # unscale temperature to add climate change
    tempSc0 <- env1a
    tempUn0 <- tempSc0 * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']

    # add climate change
    if(rcpCC == 2.6) tempUn1 <- tempUn0 + 1
    if(rcpCC == 4.5) tempUn1 <- tempUn0 + 1.8
    if(rcpCC == 6) tempUn1 <- tempUn0 + 2.2
    if(rcpCC == 8.5) tempUn1 <- tempUn0 + 3.7

    # scale warming temperature
    env1b <- (tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']

    # data frame to save solveEq output
    datEq <- setNames(data.frame(env1a, env1b, tempUn0, NA, NA, NA, NA, NA, NA, NA, NA, NA), c('env1a', 'env1b', 'env1aUnscaled', 'Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes', 'EqB', 'EqT', 'EqM', 'EqR'))

    # solveEq for each latitudinal cell
    for(i in 1:nrow(datEq))
    {
      res <- solve_Eq(func = model_fm, ENV1a = datEq[i, 'env1a'], ENV1b = datEq[i, 'env1b'],
                      growth = 'linear',
                      management = c(0, 0, 0, 0))

      datEq[i, c('EqB', 'EqT', 'EqM', 'EqR')] <- c(res[['eq']], 1 - sum(res[['eq']]))
      datEq[i, c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')] <- c(res[['deltaState']], res[['R_inf']], res[['deltaTime']], res[['R_init']], res[['integral']])

      cat('     solving to equilibrium (RCP', rcpCC, ') -> ', round(i/nrow(datEq) * 100, 0), '%\r')
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
    ci = function(x) qnorm(0.995) * sd(x)/sqrt(length(x))

    # calculate col proportion for T0 using the initial landscape

    print('[2/3] Calculate proportion of landscape rows at time T0')

    # Using any simulation because the 30 different initial landscape are the same for all simulations
    fileNames <- paste0(mainFolder, '/RCP_0_mg_0/RCP_0_mg_0_rep_', reps, '.RDS')

    # data frames to store nCol's proportion for each forest state (to be used latter for mean and IC)
    propB = propT = data.frame(matrix(rep(NA, length(reps) * nCol), ncol = reps[length(reps)]))

    for(rp in reps) {
      # get simulation
      sim <- readRDS(fileNames[rp])
      nCol <- sim[['nCol']]
      nRow <- sim[['nRow']]

      # landscape proportion
      land = matrix(sim[[paste0('land_T0')]], nrow = nCol, byrow = TRUE)
      props = apply(land, 1, getProp, nRow = nRow)
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
    env1 <- sim[['env1']] * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']
    # remove border
    env1 <- env1[-c(1, length(env1))]
    # remove border
    propSummaryT0 = propSummaryT0[c(-1, -nrow(propSummaryT0)), ]

    # Calculate col proportion for all simulations using last time step
    print('[3/3] Calculate proportion of landscape rows at time T1')

    count = 1
    for(cc in RCPs) {
      # list to store all different managements results
      listRCPProp = list()

      # for each management practice, save the mean and sd of all 30 replications
      for(mg in managPractice) {
        # name of files for each replication
        fileNames = paste0(mainFolder, '/RCP_', cc, '_mg_', mg, '/RCP_', cc, '_mg_', mg, '_rep_', reps, '.RDS')

        # data frames to store nCol's proportion for each forest state (to be used latter for mean and IC)
        propB = propT = data.frame(matrix(rep(NA, length(reps) * nCol), ncol = reps[length(reps)]))

        # get landscape proportion
        for(rp in reps) {
          # get simulation
          sim <- readRDS(fileNames[rp])
          nCol <- sim[['nCol']]
          nRow <- sim[['nRow']]

          # landscape proportion
          land = matrix(sim[[paste0('land_T', steps)]], nrow = nCol, byrow = TRUE)
          props = apply(land, 1, getProp, nRow = nRow)
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

  # Save outputs in data

    # create directory to save analysis output
    if(!dir.exists('sim-results/data')) dir.create('sim-results/data')

    # files
    filesToSave <- c(paste0('listRCPProp', RCPs), 'propSummaryT0', 'env1', 'datEq')
    save(list = filesToSave, file = paste0('sim-results/data/sim_summary_', rcpCC, '.rda'))
  #

}