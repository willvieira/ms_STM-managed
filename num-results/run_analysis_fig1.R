##########################################################################################
# Solve the model to equilibrium over the latitudinal gradient of temperature
# Data for figure 1
  # Five metrics of the transient dynamic over the latitudinal gradient
# Will Vieira
# June 20, 2019
##########################################################################################

print('Running numerical analysis for figure 1')

# source local functions and paramenters values
source('num-results/model_STM_managed.R')
source('num-results/model_STM.R')
source('num-results/solve_Eq.R')
load('num-results/sysdata.rda')

# get data.table with all five measures of the transiet analysis along the latitudinal gradient
solve_summary <- function(northLimit = -2.5,
                          southLimit = 0.35,
                          RCP,
                          RCPgrowth,
                          managPractices)
{

  # create env1 before (a) and after (b) climate change
  env1a <- seq(northLimit, southLimit, length.out = 200)

  # unscale temperature to add climate change
  tempSc0 <- env1a
  tempUn0 <- tempSc0 * vars.sd['annual_mean_temp'] + vars.means['annual_mean_temp']

  # add climate change
  if(RCP == 2.6) tempUn1 <- tempUn0 + 1 # increase of 1 degree
  if(RCP == 4.5) tempUn1 <- tempUn0 + 1.8
  if(RCP == 6) tempUn1 <- tempUn0 + 2.2
  if(RCP == 8.5) tempUn1 <- tempUn0 + 3.7
  if(RCP == 0) tempUn1 <- tempUn0

  # scale warming temperature
  env1b <- (tempUn1 - vars.means['annual_mean_temp'])/vars.sd['annual_mean_temp']

  # data frame to save solveEq output
  dat <- setNames(data.frame(env1a, env1b, tempUn0, NA, NA, NA, NA, NA, NA, NA, NA, NA), c('env1a', 'env1b', 'env1aUnscaled', 'Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes', 'EqB', 'EqT', 'EqM', 'EqR'))

  # solveEq for each latitudinal cell
  for(i in 1:nrow(dat))
  {
    # create management vector from managPrac list
    res <- solve_Eq(func = model_fm, ENV1a = dat[i, 'env1a'], ENV1b = dat[i, 'env1b'],
                    growth = RCPgrowth,
                    management = managPractices)

    dat[i, c('EqB', 'EqT', 'EqM', 'EqR')] <- c(res[['eq']], 1 - sum(res[['eq']]))
    dat[i, c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')] <- c(res[['deltaState']], res[['R_inf']], res[['deltaTime']], res[['R_init']], res[['integral']])

    cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\r')
  }
  cat('     solving to equilibrium -> ', round(i/nrow(dat) * 100, 0), '%\n')
  return(dat)
}


# get dat for noManaged and then all practices for two RCP scenarios (4.5 and 8.5)
if(!dir.exists('num-results/data/fig1')) dir.create('num-results/data/fig1', recursive=  TRUE)
practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment', 'noManaged')
CC <- c(4.5)
simulations <- expand.grid(practices, CC)
simulations$intensity <- c(0.0025, 0.01, 0.0025, 0.0025, 0)
simulations <- rbind(simulations, data.frame(Var1 = 'noCC', Var2 = 0, intensity = 0))

for(sim in 1:nrow(simulations))
{
  cat("Simulation", sim, "of", nrow(simulations), '\n')

  # name of simulation
  simName <- paste('dat', simulations[sim, 1], simulations[sim, 2], sep = '_')

  RCP <- simulations[sim, 2]
  manag <- rep(0, 4)
  manag[which(simulations[sim, 1] == practices)] <- simulations[sim, 3]

  # run simulation
  simResult <- solve_summary(northLimit = -3.5, southLimit = 0.35, RCP = RCP, RCPgrowth = 'linear', managPractices = manag)

  # save simulation
  saveRDS(simResult, file = paste0('num-results/data/fig1/', simName, '.RDS'))

}
