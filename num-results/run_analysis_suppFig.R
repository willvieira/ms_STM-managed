##########################################################################################
#  Function to get summarized data using the solveEq function
##########################################################################################

print('Running numerical analysis for supplementary figures')

# source local functions and paramenters values
source('num-results/model_STM_managed.R')
source('num-results/model_STM.R')
source('num-results/solve_Eq.R')
load('num-results/sysdata.rda')

# get data.table with all five measures of the transiet analysis along management intensity
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

# get dat for each management practices and then plot it

# two conditions of fixed environment
ev1a <- c(0, -1)

for(ENV1a in ev1a) {

  print(paste("Supplementary figure", which(ENV1a == ev1a), "of", length(ev1a)))

  print("simulation 1 of 4")
  dat_Plantation <- solve_summary(env1a = ENV1a, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(1, 0, 0, 0))
  print("simulation 2 of 4")
  dat_Harvest <- solve_summary(env1a = ENV1a, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(0, 1, 0, 0))
  print("simulation 3 of 4")
  dat_Thinning <- solve_summary(env1a = ENV1a, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(0, 0, 1, 0))
  print("simulation 4 of 4")
  dat_Enrichment <- solve_summary(env1a = ENV1a, RCP = 4.5, RCPgrowth = 'linear', managPractices = c(0, 0, 0, 1))



  #############################
  # Plot
  #############################

  practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment')
  metrics <- c('Exposure', 'Asymptotic resilience', 'Sensitivity', 'Initial resilience', 'Cumulative state changes')
  leg <- letters[1:length(metrics)]
  leg <- setNames(paste0('(', leg, ')'), metrics)

  # ylim for each variable
  nR <- nrow(dat_Plantation)
  for(mt in metrics)
  {
    vars <- rep(NA, length(practices) * nR)
    count = 0
    for(mg in practices)
    {
      vars[(nR * count + 1):(nR * (count + 1))] <- get(paste0('dat_', mg))[, mt]
      count <- count + 1
    }
    assign(paste0('ylim', mt), c(min(vars), max(vars)))
  }

  print(paste('Plot supplementary figure', which(ENV1a == ev1a)))
  pdf(file = paste0('manuscript/img/supp-num-result_env1a_', ENV1a, '.pdf'), width = 6.4)
  par(mfrow = c(3, 2), mar = c(2.1, 2.5, 1, 0.5), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 0.8)
  for(mt in metrics)
  {
    plot(0, pch = '', xlim = c(0, 1), ylim = get(paste0('ylim', mt)), xlab = '', ylab = mt, cex.lab = 1.1)
    for(mg in practices)
    {
      points(get(paste0('dat_', mg))[, c('managInt', mt)], type = 'l', lwd = 1.2, lty = which(mg == practices))
    }
    legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = leg[mt], bty = 'n', cex = 1.2)
  }

  # empty plot for legend
  plot(1, type="n", axes=F, xlab="", ylab="")
  legend('center', legend = c('Plantation', 'Harvest', 'Thinning', 'Enrichment'), lty = 1:4, bty = 'n', cex = 1)
  # text
  mtext("Management intensity", 1, line = -1, cex = .92, outer = TRUE)

  dev.off()
}
