##########################################################################################
# Solve the model to equilibrium for an increase in management intensitity
# Data for figure 2
  # Five metrics of the transient dynamic over the intensity of forest management
# Will Vieira
# June 20, 2019
##########################################################################################

print('Running numerical analysis for for figure 2')

# source local functions and paramenters values
source('num-results/model_STM_managed.R')
source('num-results/model_STM.R')
source('num-results/solve_Eq.R')
load('num-results/sysdata.rda')

# get data.table with all five metrics of the transiet dynamic along management intensity
solve_summary <- function(env1a, RCP, RCPgrowth, managPractices = c(1, 0, 0, 0))
{
  # unscale temperature to add climate change
  tempUn0 <- env1a

  # add climate change
  if(RCP == 2.6) tempUn1 <- tempUn0 + 1 # increase of 1 degree
  if(RCP == 4.5) tempUn1 <- tempUn0 + 1.8
  if(RCP == 6) tempUn1 <- tempUn0 + 2.2
  if(RCP == 8.5) tempUn1 <- tempUn0 + 3.7
  if(RCP == 0) tempUn1 <- tempUn0

  # scale warming temperature
  env1b <- unname((tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp'])
  # scale initial temperature
  env1a <- unname((tempUn0 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp'])

  # data frame to save solveEq output
  dat <- setNames(data.frame(seq(0, 1, length.out = 40), NA, NA, NA, NA, NA, NA, NA, NA, NA), c('managInt', 'Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes', 'EqB', 'EqT', 'EqM', 'EqR'))

  # management practices
  managPrac <- list()
  for(i in 1:4) {
    managPrac[[i]] <- seq(0, managPractices[i], length.out = 40)
  }

  # solveEq for each management intensity
  for(i in 1:dim(dat)[1])
  {
    # create management vector from managPrac list
    management = c(managPrac[[1]][i], managPrac[[2]][i], managPrac[[3]][i], managPrac[[4]][i])
    res <- solve_Eq(func = model_fm, ENV1a = env1a, ENV1b = env1b,
                    growth = RCPgrowth,
                    management = management)

    dat[i, c('EqB', 'EqT', 'EqM', 'EqR')] <- c(res[['eq']], 1 - sum(res[['eq']]))
    dat[i, c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')] <- c(res[['deltaState']], res[['R_inf']], res[['deltaTime']], res[['R_init']], res[['integral']])

    cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\r')
  }

  cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\n')
  return(dat)
}

# get dat for each management practices ans save it

# practices
practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment')
# two conditions of fixed environment
ev1a <- c(-1, 0)
# output folder
if(!dir.exists('num-results/data')) dir.create('num-results/data')
if(!dir.exists('num-results/data/fig2')) dir.create('num-results/data/fig2')

count = 1
for(mg in practices) {

  manag <- c(0, 0, 0, 0)
  manag[which(mg == practices)] <- 1

  for(ENV1a in ev1a) {
    print(paste0("simulation ", count, " of ", length(practices) * length(ev1a)))
    count = count + 1

    # solve simulation and save it
    saveRDS(solve_summary(env1a = ENV1a, RCP = 4.5, RCPgrowth = 'linear', managPractices = manag), file = paste0('num-results/data/fig2/dat_', mg, '_', ENV1a, '.RDS'))
  }
}
