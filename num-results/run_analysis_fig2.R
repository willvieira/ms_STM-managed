##########################################################################################
#  FIGURE 2
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

# get dat for each management practices and then plot it

# practices
practices <- c('Plantation', 'Harvest', 'Thinning', 'Enrichment')
# two conditions of fixed environment
ev1a <- c(-1, 0)

count = 1
for(mg in practices) {

  manag <- c(0, 0, 0, 0)
  manag[which(mg == practices)] <- 1

  for(ENV1a in ev1a) {
    print(paste0("simulation ", count, " of ", length(practices) * length(ev1a)))
    count = count + 1

    # solve simulation
    assign(paste0('dat_', mg, '_', ENV1a), solve_summary(env1a = ENV1a, RCP = 4.5, RCPgrowth = 'linear', managPractices = manag))
  }
}


#############################
# Plot
#############################

metrics <- c('Exposure', 'Asymptotic resilience', 'Sensitivity')
leg <- letters[1:(length(metrics) * 2)]
leg <- setNames(paste0('(', leg, ')'), do.call(paste0, expand.grid(metrics, ev1a)))

# ylim for each variable for each ENV1
nR <- nrow(dat_Plantation_0)
for(env1a in ev1a) {
  for(mt in metrics)
  {
    vars <- rep(NA, length(practices) * nR)
    count = 0
    for(mg in practices)
    {
      vars[(nR * count + 1):(nR * (count + 1))] <- get(paste0('dat_', mg, '_', env1a))[, mt]
      count <- count + 1
    }
    assign(paste0('ylim', mt, env1a), c(min(vars), max(vars)))
  }
}

# ylim for each variable independent of env1a
nR <- nrow(dat_Plantation_0)
for(mt in metrics)
{
  vars <- rep(NA, length(practices) * length(ev1a) * nR)
  count = 0
  for(env1a in ev1a) {
    for(mg in practices)
    {
      vars[(nR * count + 1):(nR * (count + 1))] <- get(paste0('dat_', mg, '_', env1a))[, mt]
      count <- count + 1
    }
  }
  assign(paste0('ylim', mt), c(min(vars), max(vars)))
}



print('Plot figure 2')


pdf(file = 'manuscript/img/num-result_2.pdf', width = 6.4, height = 6.7)
par(mfcol = c(3, 2), mar = c(1, 1.5, 0.5, 0.8), oma = c(1.5, 1, 0.5, 0), mgp = c(1.4, 0.2, 0), tck = -.008, cex = 0.8)
for(env1a in ev1a) {
  for(mt in metrics)
  {
    # empty plot
    plot(0, pch = '', xaxt = 'n', xlim = c(0, 1), ylim = get(paste0('ylim', mt)), xlab = '', ylab = '', cex.lab = 1.1)
    # xaxis
    axis(1, labels = ifelse(mt == 'Sensitivity', T, F))
    # main for env1a
    if(mt == 'Exposure') mtext(paste0('Latitude = ', env1a, ' (', ifelse(env1a == ev1a[1], 'Boreal', 'Mixed'), ')'), 3, line = 0, cex = .92)
    # ylab
    if(env1a == ev1a[1]) mtext(mt, 2, line = 1.3, cex = 0.92)

    # lines of each practices
    for(mg in practices)
    {
      points(get(paste0('dat_', mg, '_', env1a))[, c('managInt', mt)], type = 'l', lwd = 1.2, lty = which(mg == practices))
    }
    legend(par('usr')[1] - (par('usr')[2]-par('usr')[1])*0.06, par('usr')[4], legend = leg[paste0(mt, env1a)], bty = 'n', cex = 1.2)
  }

  # legend
  if(env1a == ev1a[2] & mt == 'Sensitivity') legend('topright', legend = c('Plantation', 'Harvest', 'Thinning', 'Enrichment'), lty = 1:4, bty = 'n', cex = 1)

}
mtext("Management intensity", 1, line = 0.2, cex = .92, outer = TRUE)
dev.off()
